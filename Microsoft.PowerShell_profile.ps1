# This is a fairly dodgy and person powershell profile, 
# probably best you not use too much of, just pick and choose 
# if anything :) 
set-executionpolicy unrestricted
set-alias vim "c:\program files\vim\vim72\vim.exe"
set-alias gvim_exe "c:\program files\vim\vim72\gvim.exe"
set-alias iis "c:\windows\system32\inetsrv\InetMgr.exe"

$downloads = "c:\users\rmelton\downloads\"
$documents = "c:\users\rmelton\documents\"
$oddsnends = "c:\program files\odds-n-ends"
$ep = "c:\users\rmelton\projects\ep"
$personal = "c:\users\rmelton\projects\personal"
$other = "c:\users\rmelton\projects\other"
$soa = "c:\users\rmelton\projects\ep\soa"
$config = "c:\users\rmelton\projects\EP\_configs\"
$stage = "\\192.168.30.201\c$\inetpub"
$logs = "C:\inetpub\logs\*.log"

# so lazy
$d = $downloads
$p = $personal
$o = $other

function svn_update {
    foreach ($d in $(ls)) {
        if ($d.psiscontainer) {
            svn info $d;
            svn update $d;
            svn status $d;
        }
    }
}

function hosts {
    gvim_exe C:\Windows\system32\drivers\etc\hosts
}

function mysql_sql02 {
    mysql -uroot -p -h ep2k3sql02 $args
}

function mysql_stage {
    mysql -uroot -p -h 172.20.20.22 $args
}

function mysql_local {
    mysql -uroot -p -h localhost $args
}

# Always use one window for gvim from PS
function gvim {
    if ($args) {
        gvim_exe --remote-silent $args
    } else {
        gvim_exe
    }
}

# USAGE: gvimit *.php,*.html
# That will open all the file under the current directory that are not version control helpers 
# in gvim
function gvimit {
    ls -r -in $args | ?{!$_.psiscontainer} | ?{!$($_ -match ".git")} | ?{!$($_ -match ".bzr")} | ?{!$($_ -match ".svn")} | %{gvim $_.fullname;}
}

function prompt {
    $computername = ($env:computername).tolower()
    $username = ($env:username).tolower()
    $location = (get-location).path
    $host.ui.rawui.windowtitle = $location
    $private:h = @(get-history)
    $private:nextcommand = $private:h[$private:h.count - 1].id + 1
    $wi = [system.security.principal.windowsidentity]::getcurrent()
    $wp = new-object 'system.security.principal.windowsprincipal' $wi

    write-host -nonewline -foregroundcolor white "["
    write-host -nonewline -foregroundcolor green $private:nextcommand
    write-host -nonewline -foregroundcolor white "]["

    if ( $wp.isinrole("administrators") -eq 1 ) {
        write-host -nonewline -foregroundcolor red $username
    } else {
        write-host -nonewline -foregroundcolor yellow $username
    }

    write-host -nonewline -foregroundcolor white "."
    write-host -nonewline -foregroundcolor cyan ($env:computername).tolower() 
    write-host -nonewline -foregroundcolor white " "
    write-host -nonewline -foregroundcolor yellow $location
    write-host -nonewline -foregroundcolor white "]"
    write-host -nonewline -foregroundcolor magenta "$"
    return " "
}
# vim: set ft=ps1:
