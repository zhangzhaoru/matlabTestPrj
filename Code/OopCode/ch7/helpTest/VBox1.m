f = figure();
b = uiextras.VBox( 'Parent', f );
uicontrol( 'Parent', b, 'Background', 'r' )
uicontrol( 'Parent', b, 'Background', 'b' )
uicontrol( 'Parent', b, 'Background', 'g' )
set( b, 'Sizes', [-1 100 -2], 'Spacing', 5 );