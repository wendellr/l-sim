#!/bin/perl
# Funcoes KML auxiliares

#---------------------------------------------------------------------------
$kml_header=
"<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\" xmlns:kml=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">
<Document>
	<name>L-SIM</name>
	<StyleMap id=\"msn_antenna\">
		<Pair>
			<key>normal</key>
			<styleUrl>#sn_antenna</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#sh_antenna</styleUrl>
		</Pair>
	</StyleMap>
	<StyleMap id=\"msn_Radio_Circle_Red\">
		<Pair>
			<key>normal</key>
			<styleUrl>#sn_Radio_Circle_Red</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#sh_Radio_Circle_Red</styleUrl>
		</Pair>
	</StyleMap>
	<Style id=\"sh_lightning-icon\">
		<IconStyle>
			<scale>1</scale>
			<Icon>
				<href>http://icons.iconarchive.com/icons/paomedia/small-n-flat/64/lightning-icon.png</href>
			</Icon>
		</IconStyle>
		<ListStyle>
		</ListStyle>
	</Style>
	<StyleMap id=\"msn_lightning-icon\">
		<Pair>
			<key>normal</key>
			<styleUrl>#sn_lightning-icon</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#sh_lightning-icon</styleUrl>
		</Pair>
	</StyleMap>
	<StyleMap id=\"msn_Radio_Circle_Green\">
		<Pair>
			<key>normal</key>
			<styleUrl>#sn_Radio_Circle_Green</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#sh_Radio_Circle_Green</styleUrl>
		</Pair>
	</StyleMap>
	<Style id=\"sn_antenna\">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>https://cdn4.iconfinder.com/data/icons/LUMINA/networking/png/64/antenna.png</href>
			</Icon>
		</IconStyle>
		<ListStyle>
		</ListStyle>
	</Style>
	<Style id=\"sn_Radio_Circle_Green\">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>http://individual.icons-land.com/IconsPreview/POI/PNG/Circled/64x64/Radio_Circle_Green.png</href>
			</Icon>
		</IconStyle>
		<ListStyle>
		</ListStyle>
	</Style>
	<Style id=\"sh_antenna\">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>https://cdn4.iconfinder.com/data/icons/LUMINA/networking/png/64/antenna.png</href>
			</Icon>
		</IconStyle>
		<ListStyle>
		</ListStyle>
	</Style>
	<Style id=\"sh_Radio_Circle_Red\">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>http://individual.icons-land.com/IconsPreview/POI/PNG/Circled/32x32/Radio_Circle_Red.png</href>
			</Icon>
		</IconStyle>
		<ListStyle>
		</ListStyle>
	</Style>
	<Style id=\"s_ylw-pushpin_hl\">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>https://cdn2.iconfinder.com/data/icons/weather-24/256/Storm-64.png</href>
			</Icon>
			<hotSpot x=\"0.5\" y=\"0.5\" xunits=\"fraction\" yunits=\"fraction\"/>
		</IconStyle>
		<ListStyle>
		</ListStyle>
	</Style>
	<Style id=\"sn_Radio_Circle_Red\">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>http://individual.icons-land.com/IconsPreview/POI/PNG/Circled/64x64/Radio_Circle_Red.png</href>
			</Icon>
		</IconStyle>
		<ListStyle>
		</ListStyle>
	</Style>
	<Style id=\"sh_Radio_Circle_Green\">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>http://individual.icons-land.com/IconsPreview/POI/PNG/Circled/64x64/Radio_Circle_Green.png</href>
			</Icon>
		</IconStyle>
		<ListStyle>
		</ListStyle>
	</Style>
	<StyleMap id=\"m_ylw-pushpin\">
		<Pair>
			<key>normal</key>
			<styleUrl>#s_ylw-pushpin</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#s_ylw-pushpin_hl</styleUrl>
		</Pair>
	</StyleMap>
	<Style id=\"s_ylw-pushpin\">
		<IconStyle>
			<scale>2</scale>
			<Icon>
				<href>https://cdn2.iconfinder.com/data/icons/weather-24/256/Storm-64.png</href>
			</Icon>
			<hotSpot x=\"0.5\" y=\"0.5\" xunits=\"fraction\" yunits=\"fraction\"/>
		</IconStyle>
		<ListStyle>
		</ListStyle>
	</Style>
	<Style id=\"sn_lightning-icon\">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>http://icons.iconarchive.com/icons/paomedia/small-n-flat/64/lightning-icon.png</href>
			</Icon>
		</IconStyle>
		<ListStyle>
		</ListStyle>
	</Style>
	<Folder>
";

$kml_footer = "
</Folder>
</Document>
</kml>
";
#---------------------------------------------------------------------------

sub kml_plotpoint{
  my ($lat,$lon) = @_;
  print FILE1 "
    <Point>
        <coordinates>$lon,$lat,0</coordinates>
    </Point>
  ";
}

sub kml_openfile{
  my $file1 = "a.kml";
  open FILE1, '>'.$file1;
}

sub kml_stations{
  my (@st) = @_;

  kml_openfile();

  my $i;
  print FILE1 $kml_header;
  for ($i=0;$i<=$#st;$i++) {
    print FILE1 "<Placemark>\n<styleUrl>#msn_Radio_Circle_Red</styleUrl>\n";
    kml_plotpoint($st[$i]{'lat'},$st[$i]{'lon'});
    print FILE1 "\n</Placemark>\n";
  }
  print FILE1 $kml_footer;
  close FILE1;
}

sub kml_strike{
  my (%r) = %{$_[0]};
  my (@st) = @{$_[1]};

  kml_openfile();

  my $i;
  print FILE1 $kml_header;

  print FILE1 "<Placemark>\n<styleUrl>#m_ylw-pushpin</styleUrl>\n";
  kml_plotpoint($r{'lat'},$r{'lon'});
  print FILE1 "\n</Placemark>\n";

  for ($i=0;$i<=$#st;$i++) {
    print FILE1 "<Placemark>\n<styleUrl>#msn_Radio_Circle_Red</styleUrl>\n";
    kml_plotpoint($st[$i]{'lat'},$st[$i]{'lon'});
    print FILE1 "\n</Placemark>\n";
  }
  print FILE1 $kml_footer;
  close FILE1;
}

sub kml_detectors{
  my (%r) = %{$_[0]};
  my (@st) = @{$_[1]};
  my (@dt) = @{$_[2]};

  kml_openfile();

  my $i;
  print FILE1 $kml_header;

  print FILE1 "<Placemark>\n<styleUrl>#m_ylw-pushpin</styleUrl>\n";
  kml_plotpoint($r{'lat'},$r{'lon'});
  print FILE1 "\n</Placemark>\n";

  for ($i=0;$i<=$#st;$i++) {
    $achou=0;
    for ($j=0;$j<=$#dt;$j++) {
     if (($st[$i]{'lat'} == $dt[$j]{'lat'}) && ($st[$i]{'lon'} == $dt[$j]{'lon'})) {
       $achou=1;
     }
    }

    if ($achou) {
     print FILE1 "<Placemark>\n<styleUrl>#msn_Radio_Circle_Green</styleUrl>\n";
    } else {
     print FILE1 "<Placemark>\n<styleUrl>#msn_Radio_Circle_Red</styleUrl>\n";
    }
    kml_plotpoint($st[$i]{'lat'},$st[$i]{'lon'});
    print FILE1 "\n</Placemark>\n";
  }

  print FILE1 $kml_footer;
  close FILE1;
}

sub kml_regions{
  my (%r) = %{$_[0]};
  my (@st) = @{$_[1]};
  my (@dt) = @{$_[2]};
  my (@rg) = @{$_[3]};

  kml_openfile();

  my $i;
  print FILE1 $kml_header;

  print FILE1 "<Placemark>\n<styleUrl>#m_ylw-pushpin</styleUrl>\n";
  kml_plotpoint($r{'lat'},$r{'lon'});
  print FILE1 "\n</Placemark>\n";

  for ($i=0;$i<=$#st;$i++) {
    $achou=0;
    for ($j=0;$j<=$#dt;$j++) {
     if (($st[$i]{'lat'} == $dt[$j]{'lat'}) && ($st[$i]{'lon'} == $dt[$j]{'lon'})) {
       $achou=1;
     }
    }

    if ($achou) {
     print FILE1 "<Placemark>\n<styleUrl>#msn_Radio_Circle_Green</styleUrl>\n";
    } else {
     print FILE1 "<Placemark>\n<styleUrl>#msn_Radio_Circle_Red</styleUrl>\n";
    }
    kml_plotpoint($st[$i]{'lat'},$st[$i]{'lon'});
    print FILE1 "\n</Placemark>\n";
  }

  for ($i=0;$i<=$#dt;$i++) {
	print FILE1 "<Placemark>\n<Polygon>
	<tessellate>1</tessellate>
	<altitudeMode>clampToGround</altitudeMode>
	<outerBoundaryIs><LinearRing><coordinates>";
  
    for ($z=0;$z<720;$z++) {
      print FILE1 "$rg[$i][$z]{'lon'},$rg[$i][$z]{'lat'},0\n";
    }

	$cor = sprintf("%x0%d0%d022",($i+8)%16,$i,$i);
	print FILE1 "
	</coordinates>
	</LinearRing></outerBoundaryIs>
	</Polygon>
	<Style><PolyStyle>  
   	<color>#$cor</color>
  	<outline>0</outline>
  	</PolyStyle> 
 	</Style>
	</Placemark>";

  }

  print FILE1 $kml_footer;
  close FILE1;
}

sub kml_found{
  my (%r) = %{$_[0]};
  my (@st) = @{$_[1]};
  my (@dt) = @{$_[2]};
  my (@rg) = @{$_[3]};
  my (%rf) = %{$_[4]};

  kml_openfile();

  my $i;
  print FILE1 $kml_header;

  print FILE1 "<Placemark>\n<styleUrl>#m_ylw-pushpin</styleUrl>\n";
  kml_plotpoint($r{'lat'},$r{'lon'});
  print FILE1 "\n</Placemark>\n";

  print FILE1 "<Placemark>\n<styleUrl>#msn_lightning-icon</styleUrl>\n";
  kml_plotpoint($rf{'lat'},$rf{'lon'});
  print FILE1 "\n</Placemark>\n";

  for ($i=0;$i<=$#st;$i++) {
    $achou=0;
    for ($j=0;$j<=$#dt;$j++) {
     if (($st[$i]{'lat'} == $dt[$j]{'lat'}) && ($st[$i]{'lon'} == $dt[$j]{'lon'})) {
       $achou=1;
     }
    }

    if ($achou) {
     print FILE1 "<Placemark>\n<styleUrl>#msn_Radio_Circle_Green</styleUrl>\n";
    } else {
     print FILE1 "<Placemark>\n<styleUrl>#msn_Radio_Circle_Red</styleUrl>\n";
    }
    kml_plotpoint($st[$i]{'lat'},$st[$i]{'lon'});
    print FILE1 "\n</Placemark>\n";
  }

  for ($i=0;$i<=$#dt;$i++) {
	print FILE1 "<Placemark>\n<Polygon>
	<tessellate>1</tessellate>
	<altitudeMode>clampToGround</altitudeMode>
	<outerBoundaryIs><LinearRing><coordinates>";
  
    for ($z=0;$z<720;$z++) {
      print FILE1 "$rg[$i][$z]{'lon'},$rg[$i][$z]{'lat'},0\n";
    }

	$cor = sprintf("%x0%d0%d022",($i+8)%16,$i,$i);
	print FILE1 "
	</coordinates>
	</LinearRing></outerBoundaryIs>
	</Polygon>
	<Style><PolyStyle>  
   	<color>#$cor</color>
  	<outline>0</outline>
  	</PolyStyle> 
 	</Style>
	</Placemark>";

  }

  print FILE1 $kml_footer;
  close FILE1;
}
