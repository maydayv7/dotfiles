menu(type='*' where=(sel.count or wnd.is_taskbar or wnd.is_edit) title=title.terminal sep='top' image=icon.run_with_powershell)
{
  $tip_run_admin=["Press SHIFT to run " + this.title + " as administrator", tip.warning, 1.0]
	$has_admin=key.shift() or key.rbutton()
	$terminal_dir=if(sel.dir, sel.dir, user.dir)
		
	item(title='Command Prompt' tip=tip_run_admin admin=has_admin image=icon.command_prompt cmd='wt.exe' args='new-tab -p "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}" -d "@terminal_dir\."')
	item(title='PowerShell' tip=tip_run_admin admin=has_admin image=icon.windows_powershell cmd='wt.exe' args='new-tab -p "{574e775e-4f2a-5b96-ac1e-a2962a402336}" -d "@terminal_dir\."')
}
