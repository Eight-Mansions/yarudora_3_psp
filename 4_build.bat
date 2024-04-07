del error.txt

del exe\EBOOT.BIN
copy exe\EBOOT.BIN.ORIG exe\UCJS10014.BIN

tools\armips code\exe.asm

echo trans\00304FB0.txt >> error.txt
tools\atlas exe\UCJS10014.BIN trans\00304FB0.txt >> error.txt
echo trans\exe_emb.txt >> error.txt
tools\atlas exe\UCJS10014.BIN trans\exe_emb.txt >> error.txt
echo trans\exe_menu_options.txt >> error.txt
tools\atlas exe\UCJS10014.BIN trans\exe_menu_options.txt >> error.txt

tools\sign_np-v1.0.4-windows-x86_x64.exe -elf exe\UCJS10014.BIN exe\EBOOT.BIN 02

del graphics\*.arc
del graphics\data\*.arc

xcopy /s graphics\_orig\* graphics

del /q /s graphics\*.gim
for /R "graphics" %%i in (*.png) do (tools\pngnq.exe -s 1 -n 256 -d %%~pi %%i)
for /R "graphics" %%A in (*.gim-nq8.png) do (
    for %%B in ("%%~nA") do (
		tools\gimconv.exe %%~A --format_endian little --pixel_order faster --image_format index8 --palette_format rgba8888 -o %%~nB.gim
    )
)
del /q /s graphics\*-nq8*.png

tools\psp_wpx_tool.exe i graphics\font21.arc graphics\font21_arc\sys_font01.gim

tools\psp_wpx_tool.exe i graphics\data\fiction.arc graphics\data\fiction_arc\fiction.gim

tools\psp_wpx_tool.exe i graphics\data\start.arc graphics\data\start_arc\4title_bg.gim

tools\psp_wpx_tool.exe i graphics\data\wallpaper02.arc graphics\data\wallpaper02_arc\bg02.gim
tools\psp_wpx_tool.exe i graphics\data\wallpaper03.arc graphics\data\wallpaper03_arc\bg03.gim

tools\psp_wpx_tool.exe i graphics\data\name.arc graphics\data\name_arc\03name_parts.gim
tools\psp_wpx_tool.exe i graphics\data\name2.arc graphics\data\name2_arc\04name_parts.gim

tools\psp_wpx_tool.exe i graphics\data\title.arc graphics\data\title_arc\title_parts.gim

tools\psp_wpx_tool.exe i graphics\data\omake.arc graphics\data\omake_arc\omake_parts.gim
tools\psp_wpx_tool.exe i graphics\data\omake.arc graphics\data\omake_arc\omake_02.gim
tools\psp_wpx_tool.exe i graphics\data\omake1.arc graphics\data\omake1_arc\omake_parts_1.gim
tools\psp_wpx_tool.exe i graphics\data\omake2.arc graphics\data\omake2_arc\omake_parts_2.gim
tools\psp_wpx_tool.exe i graphics\data\omake2.arc graphics\data\omake2_arc\omake_02.gim
tools\psp_wpx_tool.exe i graphics\data\omake3.arc graphics\data\omake3_arc\omake_parts_3.gim
tools\psp_wpx_tool.exe i graphics\data\omake4.arc graphics\data\omake4_arc\omake_parts_4.gim

tools\psp_wpx_tool.exe i graphics\data\end_01.arc graphics\data\end_01_arc\end_01.gim
tools\psp_wpx_tool.exe i graphics\data\end_02.arc graphics\data\end_02_arc\end_02.gim
tools\psp_wpx_tool.exe i graphics\data\end_03.arc graphics\data\end_03_arc\end_03.gim
tools\psp_wpx_tool.exe i graphics\data\end_04.arc graphics\data\end_04_arc\end_04.gim

tools\psp_wpx_tool.exe i graphics\data\window.arc graphics\data\window_arc\window01.gim
tools\psp_wpx_tool.exe i graphics\data\window2.arc graphics\data\window2_arc\window02.gim

tools\psp_wpx_tool.exe i graphics\data\logo41.arc graphics\data\logo41_arc\mcard01.gim
tools\psp_wpx_tool.exe i graphics\data\logo42.arc graphics\data\logo42_arc\mcard01.gim
tools\psp_wpx_tool.exe i graphics\data\logo43.arc graphics\data\logo43_arc\mcard01.gim
tools\psp_wpx_tool.exe i graphics\data\logo44.arc graphics\data\logo44_arc\mcard01.gim

tools\psp_wpx_tool.exe i graphics\data\logo51.arc graphics\data\logo51_arc\mcard02.gim
tools\psp_wpx_tool.exe i graphics\data\logo52.arc graphics\data\logo52_arc\mcard02.gim
tools\psp_wpx_tool.exe i graphics\data\logo53.arc graphics\data\logo53_arc\mcard02.gim
tools\psp_wpx_tool.exe i graphics\data\logo54.arc graphics\data\logo54_arc\mcard02.gim

tools\psp_wpx_tool.exe i graphics\data\logo71.arc graphics\data\logo71_arc\TYUUI.gim
tools\psp_wpx_tool.exe i graphics\data\logo72.arc graphics\data\logo72_arc\TYUUI.gim
tools\psp_wpx_tool.exe i graphics\data\logo73.arc graphics\data\logo73_arc\TYUUI.gim
tools\psp_wpx_tool.exe i graphics\data\logo74.arc graphics\data\logo74_arc\TYUUI.gim

tools\psp_wpx_tool.exe i graphics\data\sl.arc graphics\data\sl_arc\sl_parts.gim
tools\psp_wpx_tool.exe i graphics\data\sl1.arc graphics\data\sl1_arc\sl_parts_1.gim
tools\psp_wpx_tool.exe i graphics\data\sl2.arc graphics\data\sl2_arc\sl_parts_2.gim
tools\psp_wpx_tool.exe i graphics\data\sl3.arc graphics\data\sl3_arc\sl_parts_3.gim
tools\psp_wpx_tool.exe i graphics\data\sl4.arc graphics\data\sl4_arc\sl_parts_4.gim

tools\psp_wpx_tool.exe i graphics\data\rate.arc graphics\data\rate_arc\rate_parts.gim

tools\psp_wpx_tool.exe i graphics\data\look.arc graphics\data\look_arc\look_parts.gim

tools\psp_wpx_tool.exe i graphics\data\replay.arc graphics\data\replay_arc\list_parts.gim
tools\psp_wpx_tool.exe i graphics\data\replay1.arc graphics\data\replay1_arc\list_parts_1.gim
tools\psp_wpx_tool.exe i graphics\data\replay2.arc graphics\data\replay2_arc\list_parts_2.gim
tools\psp_wpx_tool.exe i graphics\data\replay3.arc graphics\data\replay3_arc\list_parts_3.gim
tools\psp_wpx_tool.exe i graphics\data\replay4.arc graphics\data\replay4_arc\list_parts_4.gim

tools\psp_wpx_tool.exe i graphics\data\replay2_1.arc graphics\data\replay2_1_arc\list_parts_1.gim
tools\psp_wpx_tool.exe i graphics\data\replay2_2.arc graphics\data\replay2_2_arc\list_parts_2.gim
tools\psp_wpx_tool.exe i graphics\data\replay2_3.arc graphics\data\replay2_3_arc\list_parts_3.gim
tools\psp_wpx_tool.exe i graphics\data\replay2_4.arc graphics\data\replay2_4_arc\list_parts_4.gim

del cd\yarudora_3\PSP_GAME\SYSDIR\EBOOT.BIN
copy exe\eboot.bin cd\yarudora_3\PSP_GAME\SYSDIR\EBOOT.BIN

xcopy graphics\font21.arc cd\yarudora_3\PSP_GAME\USRDIR\font21.arc /Y
xcopy graphics\font21.arc cd\yarudora_3\PSP_GAME\USRDIR\font22.arc /Y
xcopy graphics\font21.arc cd\yarudora_3\PSP_GAME\USRDIR\font23.arc /Y
xcopy graphics\font21.arc cd\yarudora_3\PSP_GAME\USRDIR\font24.arc /Y

xcopy graphics\data\*.arc cd\yarudora_3\PSP_GAME\USRDIR\data\* /Y

xcopy ins\* cd\yarudora_3\PSP_GAME\USRDIR\data\IGX003\* /Y /s

del cd\yarudora_3.iso
tools\mkisofs -iso-level 4 -xa -A "PSP GAME" -V "SAMPAGUITA" -sysid "PSP GAME" -volset "" -p "" -publisher "" -o cd/yarudora_3.iso cd/yarudora_3