ACLS

XMAX=15
YMAX=10
DIM SMAP[XMAX,YMAX] 'スプライト ノ マップ
DIM PMAP[XMAX,YMAX] 'コマ ノ マップ
MX=(400-XMAX*16)/2  'Xイチ ノ マージン
MY=(240-YMAX*16)/2  'Yイチ ノ マージン

DIM PS[3] 'シヨウスル コマ
PS[0]=22  'エメラルド
PS[1]=23  'ルビー
PS[2]=24  'ダイヤモンド

CS=0 'カーソル ノ スプライト バンゴウ
CX=0 'カーソル ノ Xイチ
CY=0 'カーソル ノ Yイチ

GOSUB @INITMAP
GOSUB @INITCS

END 'プログラム シュウリョウ

'マップ ノ ショキカ
@INITMAP
S=1 'スプライト バンゴウ 1 カラ ハジメル
FOR Y=0 TO YMAX-1
 FOR X=0 TO XMAX-1
  P=PS[RND(3)]
  SPSET S,P
  SPOFS S,X*16+MX,Y*16+MY
  SMAP[X,Y]=S
  PMAP[X,Y]=P
  INC S
 NEXT
NEXT
RETURN

'カーソル ノ ショキカ
@INITCS
SPSET CS,298
SPOFS CS,CX*16+MX,CY*16+MY
RETURN