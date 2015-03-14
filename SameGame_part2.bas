'
' SAMEGAME
'

ACLS
BGMPLAY 27

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

'メインループ
WHILE 1
 B=BUTTON(1)
 MOVE B
 IF B==16 THEN 'Aボタン
  C=NDEL(CX,CY,PMAP[CX,CY])
  GOSUB @VPACK
  GOSUB @HPACK
 ENDIF
 IF B==64 THEN 'Xボタン
  BREAK
 ENDIF
 VSYNC 1
WEND

BGMSTOP
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

'カーソル ノ イドウ
DEF MOVE B
 IF B AND 1 THEN DEC CY 'ウエ
 IF B AND 2 THEN INC CY 'シタ
 IF B AND 4 THEN DEC CX 'ヒダリ
 IF B AND 8 THEN INC CX 'ミギ
 IF CX<0 THEN CX=XMAX-1
 IF CX>=XMAX THEN CX=0
 IF CY<0 THEN CY=YMAX-1
 IF CY>=YMAX THEN CY=0
 SPOFS CS,CX*16+MX,CY*16+MY
END

'コマヲ サクジョ
DEF DEL X,Y
 IF SMAP[X,Y]!=0 THEN
  SPCLR SMAP[X,Y]
  SMAP[X,Y]=0
  PMAP[X,Y]=0
  BEEP 51
  VSYNC 2
 ENDIF
END

'リンセツノ コマヲ サクジョ
DEF NDEL(X,Y,P)
 VAR C=0 'サクジョシタ コマノ カズ
 IF PMAP[X,Y]==0 THEN RETURN C
 DEL X,Y
 INC C
 IF Y>0 && P==PMAP[X,Y-1] THEN
  C=C+NDEL(X,Y-1,P) 'ウエ ノ コマ サクジョ
 ENDIF
 IF Y<YMAX-1 && P==PMAP[X,Y+1] THEN
  C=C+NDEL(X,Y+1,P) 'シタ ノ コマ サクジョ
 ENDIF
 IF X>0 && P==PMAP[X-1,Y] THEN
  C=C+NDEL(X-1,Y,P) 'ヒダリ ノ コマ サクジョ
 ENDIF
 IF X<XMAX-1 && P==PMAP[X+1,Y] THEN
  C=C+NDEL(X+1,Y,P) 'ミギ ノ コマ サクジョ
 ENDIF
 RETURN C
END

'タテノ スキマヲ ナクス
@VPACK
FOR X=0 TO XMAX-1
 FOR Y=YMAX-1 TO 0 STEP-1
  IF PMAP[X,Y]==0 THEN 'スキマヲ ミツケタ
   FOR YY=Y-1 TO 0 STEP-1
    IF PMAP[X,YY]!=0 THEN 'スキマノ ウエノ コマ
     SPOFS SMAP[X,YY],X*16+MX,Y*16+MY 'オトス
     SWAP SMAP[X,Y],SMAP[X,YY]
     SWAP PMAP[X,Y],PMAP[X,YY]
     VSYNC 1
     BREAK
    ENDIF
   NEXT
  ENDIF
 NEXT
NEXT
RETURN

'ヨコノ スキマヲ ナクス
@HPACK
FOR X=XMAX-1 TO 0 STEP-1
 FOUND=FALSE
 FOR Y=0 TO YMAX-1
  IF PMAP[X,Y]!=0 THEN
   FOUND=TRUE 'レツノ ナカニ コマガ アル
   BREAK
  ENDIF
 NEXT
 IF FOUND==FALSE THEN
  GOSUB @HPACKSUB
 ENDIF
NEXT
RETURN

'イチレツ ヒダリニ ズラス
@HPACKSUB
FOR XX=X+1 TO XMAX-1
 FOR YY=0 TO YMAX-1
  SPOFS SMAP[XX,YY],(XX-1)*16+MX,YY*16+MY
  SWAP SMAP[XX,YY],SMAP[XX-1,YY]
  SWAP PMAP[XX,YY],PMAP[XX-1,YY]
 NEXT
NEXT
RETURN
