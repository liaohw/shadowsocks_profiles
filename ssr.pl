#! /usr/bin/env perl
my $s = 0;
my @c;
while(<>)
{
    chomp;
    push @c,$_ if($s);
    if(/<tbody>/){ $s=1;}
    last if(/<\/tbody>/);
}
my $cs = join('',@c);
my @pl;
my $id=1;
while($cs =~ /<tr><td>([^<]*)<\/td><td>(\d+)\.(\d+)\.(\d+)\.(\d+)<\/td><td>(\d+)<\/td><td>([^<]*)<\/td><td>([^<]*)<\/td><td>([^<]*)<\/td><td>([^<]*)<\/td><\/tr>/mg) {
    #push @pl, {Remark=>$1,ServerHost=>"$2.$3.$4.$5",ServerPort=>"$6",Password=>"$7",Method=>"$8",ssrProtocol=>"$9",ssrObfs=>"$10",Id=>"$id",ssrGroup=>"",ssrObfsParam=>"",ssrProtocolParam=>""};
   my $str="
   <dict>
   <key>Id</key>
   <string>$id</string>
   <key>Method</key>
   <string>$8</string>
   <key>Password</key>
   <string>$7</string>
   <key>Remark</key>
   <string>$1</string>
   <key>ServerHost</key>
   <string>$2.$3.$4.$5</string>
   <key>ServerPort</key>
   <integer>$6</integer>
   <key>ssrGroup</key>
   <string></string>
   <key>ssrObfs</key>
   <string>$10</string>
   <key>ssrObfsParam</key>
   <string></string>
   <key>ssrProtocol</key>
   <string>$9</string>
   <key>ssrProtocolParam</key>
   <string></string>
   </dict>";
    push @pl, $str;
    #print "$1 $2.$3.$4.$5 $6 $7 $8 $9 $10\n";
    $id = $id+1;
}
die "no avaliable proxy" if scalar(@pl) <=0;

my $plss=join('',@pl);
print<<EOF;
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>ACLFileName</key>
    <string></string>
    <key>ActiveServerProfileId</key>
    <string>1</string>
    <key>AutoConfigureNetworkServices</key>
    <true/>
    <key>AutoUpdateSubscribe</key>
    <true/>
    <key>ConnectAtLaunch</key>
    <true/>
    <key>LocalSocks5.ListenPort.Old</key>
    <integer>1086</integer>
    <key>NSNavLastRootDirectory</key>
    <string>~/Documents</string>
    <key>NSNavLastUserSetHideExtensionButtonState</key>
    <false/>
    <key>NSNavPanelExpandedSizeForOpenMode</key>
    <string>{799, 448}</string>
    <key>NSNavPanelExpandedSizeForSaveMode</key>
    <string>{712, 448}</string>
    <key>NSStatusItem Preferred Position Item-0</key>
    <real>441</real>
    <key>NSWindow Frame NSNavPanelAutosaveName</key>
    <string>467 458 345 181 0 0 1280 777 </string>
    <key>Proxy4NetworkServices</key>
    <array/>
    <key>ServerProfiles</key>
    <array>
    $plss
    </array>
    <key>ShadowsocksOn</key>
    <false/>
    <key>ShadowsocksRunningMode</key>
    <string>auto</string>
    <key>Subscribes</key>
    <array>
        <dict>
            <key>feed</key>
            <string>https://ssrtool.us/tool/free_ssr</string>
            <key>group</key>
            <string>New Subscribe</string>
            <key>maxCount</key>
            <integer>-1</integer>
            <key>token</key>
            <string></string>
        </dict>
    </array>
    <key>enable_showSpeed</key>
    <true/>
</dict>
</plist>
EOF
