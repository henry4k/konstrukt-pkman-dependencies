// We want assert:
#if defined(NDEBUG)
#undef NDEBUG
#endif

#define _WIN32_WINNT 0x0601 // use Windows 7 API level
#define WIN32_LEAN_AND_MEAN
#define NOGDI
#include <windows.h> // GetModuleFileNameW, CreateProcessW, ...
#include <shellapi.h> // SHGetPropertyStoreForWindow
#include <propsys.h>
#include <propkey.h>
#include <propvarutil.h>

#include <stdio.h> // fopen, fseek, ...
#include <assert.h>
#include <string.h> // memset, memcpy


#define Error(Message) \
    FatalAppExitA(0, (Message))

static const wchar_t* GetExecutablePath()
{
    static wchar_t executablePath[MAX_PATH];
    if(!GetModuleFileNameW(NULL, executablePath, MAX_PATH))
        Error("Can't retrieve executable file name.");
    return executablePath;
}

static const wchar_t* GetPayload()
{
    const wchar_t* executablePath = GetExecutablePath();
    FILE* executable = _wfopen(executablePath, L"rb");
    assert(executable);

    // <launcher:023> <- 23 bytes of payload
    static const int tagLength = 14;

    fseek(executable, -tagLength, SEEK_END);

    int payloadLength;
    if(fscanf(executable, "<launcher:%d>", &payloadLength) != 1)
        Error("Payload tag was not found.");

    assert(payloadLength > 0);
    assert(payloadLength <= MAX_PATH);
    fseek(executable, -(tagLength+payloadLength), SEEK_END);
    char payload[MAX_PATH];
    fread(payload, payloadLength, 1, executable);

    fclose(executable);

    static wchar_t payloadW[MAX_PATH];
    swprintf(payloadW, MAX_PATH, L"%hs", payload); // convert to wchar_t
    return payloadW;
}

static PROCESS_INFORMATION LaunchProcess( const wchar_t* application, const wchar_t* arguments )
{
    wchar_t commandLine[4096];
    if(_snwprintf(commandLine, sizeof(commandLine), L"\"%s\" %s", application, arguments) == -1)
        Error("Can\'t create command line.");

    STARTUPINFOW startupInfo;
    memset(&startupInfo, 0, sizeof(startupInfo));
    startupInfo.cb = sizeof(startupInfo);
    //startupInfo.dwFlags = STARTF_USESTDHANDLES;

    PROCESS_INFORMATION processInformation;
    memset(&processInformation, 0, sizeof(processInformation));

    if(!CreateProcessW(NULL, // applicationName
                       commandLine, // commandLine
                       NULL, // processAttributes
                       NULL, // threadAttributes
                       false, // inheritHandles
                       0, // creationFlags
                       NULL, // environment
                       NULL, // workingDirectory
                       &startupInfo, // startupInfo
                       &processInformation)) // processInformation
    {
        Error("Can't create process.");
    }

    return processInformation;
}

static const wchar_t* GetBaseName( const wchar_t* path )
{
    const wchar_t* baseNameStart = wcsrchr(path, L'\\');
    if(baseNameStart)
        baseNameStart++;
    else
        baseNameStart = path;

    static wchar_t baseName[MAX_PATH];
    for(int i = 0; true; i++)
    {
        if(baseNameStart[i] == L'.' ||
           baseNameStart[i] == L'\0')
        {
            baseName[i] = L'\0';
            break;
        }
        else
        {
            baseName[i] = baseNameStart[i];
        }
    }

    return baseName;
}

static void SetPropertyStoreValue( IPropertyStore* propertyStore,
                                   REFPROPERTYKEY key,
                                   const wchar_t* value )
{
    size_t valueLength = wcslen(value)+1;
    wchar_t* valueCopy = new wchar_t[valueLength];
    memcpy(valueCopy, value, sizeof(wchar_t)*valueLength);

    PROPVARIANT variable;
    PropVariantInit(&variable);

    variable.pwszVal = valueCopy;
    variable.vt = VT_LPWSTR;

    if(!SUCCEEDED(propertyStore->SetValue(key, variable)))
        Error("Can't set property value.");

    PropVariantClear(&variable);
}

static void SetPinningProperties( HWND window )
{
    const wchar_t* executable = GetExecutablePath();
    const wchar_t* baseName = GetBaseName(executable);

    wchar_t id[MAX_PATH]; // konstrukt.<basename>
    swprintf(id, MAX_PATH, L"konstrukt.%ls", baseName);

    wchar_t command[MAX_PATH]; // "<executable>"
    swprintf(command, MAX_PATH, L"\"%ls\"", executable);

    wchar_t name[MAX_PATH]; // basename of executable
    swprintf(name, MAX_PATH, L"%ls", baseName);

    wchar_t icon[MAX_PATH]; // @<executable>,-1
    swprintf(icon, MAX_PATH, L"@%ls,-1", executable);

    /*
    // DEBUG START
    wchar_t windowTitle[256];
    GetWindowTextW(window, windowTitle, 255);
    wchar_t debugText[512];
    swprintf(debugText, 511, L"windowTitle: '%ls'\nexecutable: '%ls'\nbaseName: '%ls'\nid: '%ls'\ncommand: %ls\nname: '%ls'\nicon: '%ls'",
             windowTitle, executable, baseName, id, command, name, icon);
    MessageBoxW(NULL, debugText, L"SetPinningProperties", MB_OK|MB_ICONINFORMATION);
    // DEBUG END
    */

    IPropertyStore* ps;
    HRESULT result = SHGetPropertyStoreForWindow(window, IID_PPV_ARGS(&ps));
    if(SUCCEEDED(result))
    {
        SetPropertyStoreValue(ps, PKEY_AppUserModel_ID, id);
        SetPropertyStoreValue(ps, PKEY_AppUserModel_RelaunchCommand, command);
        SetPropertyStoreValue(ps, PKEY_AppUserModel_RelaunchDisplayNameResource, name);
        SetPropertyStoreValue(ps, PKEY_AppUserModel_RelaunchIconResource, icon);

        assert(SUCCEEDED(ps->Commit()));
        ps->Release();
    }
    else
    {
        assert(result == E_NOTIMPL); // happens in Wine for example
    }
}

BOOL CALLBACK EnumWindowsCb( HWND window, LPARAM param )
{
    PROCESS_INFORMATION* processInformation = (PROCESS_INFORMATION*)param;

    unsigned long processId = 0;
    GetWindowThreadProcessId(window, &processId);

    if(processId == processInformation->dwProcessId)
        SetPinningProperties(window);

    return TRUE;
}

int CALLBACK WinMain( HINSTANCE instance,
                      HINSTANCE prevInstance,
                      LPSTR     cmdLine,
                      int       cmdShow )
{
    const wchar_t* payload = GetPayload();
    PROCESS_INFORMATION processInformation = LaunchProcess(payload, GetCommandLineW());

    WaitForInputIdle(processInformation.hProcess, INFINITE);

    EnumWindows(EnumWindowsCb, (LPARAM)&processInformation);

    CloseHandle(processInformation.hProcess);
    CloseHandle(processInformation.hThread);

    return 0;
}
