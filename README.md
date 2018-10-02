Virtual File System Editor
==========================

A tool to extract embedded files from application virtualizers. This was originally released exclusively on the tuts4you forum. Made open source on April 16, 2018.

General Information
-------------------

Virtual File System Editor is a tool to extract/modify embedded files from packed executables created by application virtualizers. The main tool is provided in the form of a DLL which needs to be injected into the process you want to extract files from. Since DLL injection is a separate topic with it's own nuances, I have not provided a DLL injector in this package. You may use any DLL injector. I recommend the one developed by Ralph Hare available at [ysgyfarnog.co.uk](http://www.ysgyfarnog.co.uk/utilities/Injector/) or RemoteDLL available at [SecurityXploded](http://securityxploded.com/remotedll.php). The latter is particularly recommended for ASLR aware systems.

Program Usage
-------------

**Access Test** : Use this to check if the selected file is readable by the virtual application. Normally both access tests would pass. If the tests fail, it indicates that packer did not correctly hook the APIs. In such cases you need to find the real VA of the hooked APIs and enter it in the options dialog.

**Run** : Use this to run another application in the context of this process. For example, this can be used to run _regedit.exe_ to work with embedded registry keys. This feature has been modelled on the basis of Windows Run dialog, and will accept URLS, file paths etc. Note that if the application does not virtualize child processes it will be run of outside the virtualization container.

**Extract** : Use this to extract any files from the virtual file system. You need to ensure that the output folder is outside the virtual file system or otherwise the files will be created within it (if the filesystem is writable of course). This mode uses _SHFILEOPERATION_ function to copy selected files/directories.

**Extract by name** : Use this to extract files by specifying their path. This option is particularly useful for extracting hidden files, which are not visible in the listing. For example, [molebox virtualization solution](http://www.molebox.com/) provides an option to hide files from directory listing which uses _FindFirst_ API function. In such cases, if you know the full file path (which you may obtain by debugging the application), you can extract it using this option. Also note that this method extracts the file using vfsserver process, so you need to run it. Additionally, you can only extract files by this.

**Extract by server** : Use this to leverage the extraction of files by using a separate process(vfsserver.exe) which is run outside the virtualization container. You can use this extraction mode, if file creation is not possible within the virtualized application. You can only extract files by this method.

**Add** : You can add/copy files to the virtual file system using this method. Note that the virtual file system should be writable for this to succeed. You can only add files by this method.

**Delete** : Delete files from the virtual file system. As usual the file system should not be read-only. Also make sure that selected files are a part of the virtual file system, or otherwise real files on disk which are outside the virtualization container will be deleted. You can delete both files as well as directories by this method.

**Options** : Here you can specifiy the virtual addresses for the APIs used for extraction. You need to provide the VA of four API's namely _CreateFileA_, _GetFileSize_, _ReadFile_, & _CloseHandle_. Normally, you do not need to use this, but for very old packers such as old versions of molebox this is needed. This is because the software incorrectly hooks the IAT, as a result the newly injected dll does not use the hooked APIs. In such cases, you need to debug the application to find the VA of the said hooked APIs and then provide the values here. Also note that the provided values are only used in extract by name & server modes.

Tests
-----

Virtual File System Editor was tested with the following packers on Windows XP SP3.

*   [Cameyo 2.0.8.32](http://www.cameyo.com/)
*   [Enigma Protector 4.20.20140508](http://www.enigmaprotector.com/en/about.html)
*   [Enigma Virtual Box 7.10.20131218](http://www.enigmaprotector.com/en/aboutvb.html)
*   [Evalaze Commercial Edition 2.2.1.1](http://www.evalaze.de/)
*   [Molebox Virtualization Solution 5.4.6.2](http://www.molebox.com/)
*   [Smart Packer Pro 1.93](http://www.smartpacker.nl/)
*   [Spoon Virtual Application Studio 11.4.176](https://spoon.net/studio)
*   [VMware ThinApp Enterprise 5.0.0.1391583](http://www.vmware.com/products/thinapp)

Tips, Tricks & Limitations
--------------------------

Molebox allows to hide specific or all files from directory structure listing. This can be controlled by the "Hide all files" option or passing specific flags in the MXB file. In such a case _FindFirstFile_ / _FindNextFile_ used for directory listing will not list the hidden files & so they will not be shown in the extractor window. As a workaround, you can use the extract by name method, but you need to know the full path of the embedded file beforehand. Also the main executable cannot be unpacked by this tool. For very old versions of Molebox which incorrectly hooks the IAT you also need to specify the VA of the hooked APIs in Options.

For enigma virtual box & enigma protector, the main executable will not be unpacked. The best solution in this case is to use [Static Enigma Virtual Box Unpacker](https://forum.tuts4you.com/topic/35554-static-enigma-virtual-box-unpacker/) by [kao](http://lifeinhex.com/) which not only unpacks the main executable but also embedded registry keys(if any) along with other embedded files.

Changelog
---------

**v0.3** December 15, 2015  
• Support for large files via name & server modes  
• Fixed some bugs

**v0.2** August 22, 2015  
• Added run external program feature

**v0.1** August 26, 2014  
• First Public Release

Credits
-------

Coded in Borland Delphi 7

Virtual File System Editor uses the following :  
• [Ortus Shell Components](http://www.delphicomponents.net/)  
• [Aesthetica Icon Set version 2.0](http://dryicons.com/)
