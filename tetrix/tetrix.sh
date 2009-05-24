#!/bin/bash
# Tetris Game
# 10.21.2003 xhchen

#颜色定义
cRed=1
cGreen=2
cYellow=3
cBlue=4
cFuchsia=5
cCyan=6
cWhite=7
colorTable=($cRed $cGreen $cYellow $cBlue $cFuchsia $cCyan $cWhite)

#位置和大小
iLeft=3
iTop=2
((iTrayLeft = iLeft 2))
((iTrayTop = iTop 1))
((iTrayWidth = 10))
((iTrayHeight = 15))

#颜色设置
cBorder=$cGreen
cScore=$cFuchsia
cScoreValue=$cCyan

#控制信号
#改游戏使用两个进程，一个用于接收输入，一个用于游戏流程和显示界面;
#当前者接收到上下左右等按键时，通过向后者发送signal的方式通知后者。
sigRotate=25
sigLeft=26
sigRight=27
sigDown=28
sigAllDown=29
sigExit=30

#七中不同的方块的定义
#通过旋转，每种方块的显示的样式可能有几种
box0=(0 0 0 1 1 0 1 1)
box1=(0 2 1 2 2 2 3 2 1 0 1 1 1 2 1 3)
box2=(0 0 0 1 1 1 1 2 0 1 1 0 1 1 2 0)
box3=(0 1 0 2 1 0 1 1 0 0 1 0 1 1 2 1)
box4=(0 1 0 2 1 1 2 1 1 0 1 1 1 2 2 2 0 1 1 1 2 0 2 1 0 0 1 0 1 1 1 2)
box5=(0 1 1 1 2 1 2 2 1 0 1 1 1 2 2 0 0 0 0 1 1 1 2 1 0 2 1 0 1 1 1 2)
box6=(0 1 1 1 1 2 2 1 1 0 1 1 1 2 2 1 0 1 1 0 1 1 2 1 0 1 1 0 1 1 1 2)
#所有其中方块的定义都放到box变量中
box=($ $ $ $ $ $ $)
#各种方块旋转后可能的样式数目
countBox=(1 2 2 2 4 4 4)
#各种方块再box数组中的偏移
offsetBox=(0 1 3 5 7 11 15)

#每提高一个速度级需要积累的分数
iScoreEachLevel=50 #be greater than 7

#运行时数据
sig=0 #接收到的signal
iScore=0 #总分
iLevel=0 #速度级
boxNew=() #新下落的方块的位置定义
cBoxNew=0 #新下落的方块的颜色
iBoxNewType=0 #新下落的方块的种类
iBoxNewRotate=0 #新下落的方块的旋转角度
boxCur=() #当前方块的位置定义
cBoxCur=0 #当前方块的颜色
iBoxCurType=0 #当前方块的种类
iBoxCurRotate=0 #当前方块的旋转角度
boxCurX=-1 #当前方块的x坐标位置
boxCurY=-1 #当前方块的y坐标位置
iMap=() #背景方块图表

#初始化所有背景方块为-1, 表示没有方块
for ((i = 0; i < iTrayHeight * iTrayWidth; i )); do iMap=-1; done


#接收输入的进程的主函数
function RunAsKeyReceiver()
{
local pidDisplayer key aKey sig cESC sTTY

pidDisplayer=
aKey=(0 0 0)

cESC=`echo -ne ""`
cSpace=`echo -ne ""`

#保存终端属性。在read -s读取终端键时，终端的属性会被暂时改变。
#如果在read -s时程序被不幸杀掉，可能会导致终端混乱，
#需要在程序退出时恢复终端属性。
sTTY=`stty -g`

#捕捉退出信号
trap "MyExit;" INT TERM
trap "MyExitNoSub;" $sigExit

#隐藏光标
echo -ne "=$
aKey=$
aKey=$key
sig=0

#判断输入了何种键
if ]
then
#ESC键
MyExit
elif ]
then
if ]; then sig=$sigRotate #<向上键>
elif ]; then sig=$sigDown #<向下键>
elif ]; then sig=$sigLeft #<向左键>
elif ]; then sig=$sigRight #<向右键>
fi
elif ]; then sig=$sigRotate #W, w
elif ]; then sig=$sigDown #S, s
elif ]; then sig=$sigLeft #A, a
elif ]; then sig=$sigRight #D, d
elif " == "" ]]; then sig=$sigAllDown #空格键
elif ] #Q, q
then
MyExit
fi

if ]
then
#向另一进程发送消息
kill -$sig $pidDisplayer
fi
done
}

#退出前的恢复
function MyExitNoSub()
{
local y

#恢复终端属性
stty $sTTY
((y = iTop iTrayHeight 4))

#显示光标
echo -e "} != -1 ))
then
#撞到其他已经存在的方块了
return 1
fi
done
return 0;
}


#将当前移动中的方块放到背景方块中去,
#并计算新的分数和速度级。(即一次方块落到底部)
function Box2Map()
{
local j i x y xp yp line

#将当前移动中的方块放到背景方块中去
for ((j = 0; j < 8; j = 2))
do
((i = j 1))
((y = $ boxCurY))
((x = $ boxCurX))
((i = y * iTrayWidth x))
iMap=$cBoxCur
done

#消去可被消去的行
line=0
for ((j = 0; j < iTrayWidth * iTrayHeight; j = iTrayWidth))
do
for ((i = j iTrayWidth - 1; i >= j; i--))
do
if (($ == -1)); then break; fi
done
if ((i >= j)); then continue; fi

((line ))
for ((i = j - 1; i >= 0; i--))
do
((x = i iTrayWidth))
iMap=$
done
for ((i = 0; i < iTrayWidth; i ))
do
iMap=-1
done
done

if ((line == 0)); then return; fi

#根据消去的行数line计算分数和速度级
((x = iLeft iTrayWidth * 2 7))
((y = iTop 11))
((iScore = line * 2 - 1))
#显示新的分数
echo -ne "=$
boxCur=$
done

if BoxMove $boxCurY $boxCurX #测试旋转后是否有空间放的下
then
#抹去旧的方块
for ((j = 0; j < 8; j ))
do
boxCur=$
done
s=`DrawCurBox 0`

#画上新的方块
for ((j = 0, i = ($ $iTestRotate) * 8; j < 8; j , i ))
do
boxCur=$
done
s=$s`DrawCurBox 1`
echo -ne $s
iBoxCurRotate=$iTestRotate
else
#不能旋转，还是继续使用老的样式
for ((j = 0; j < 8; j ))
do
boxCur=$
done
fi
}


#DrawCurBox(bDraw), 绘制当前移动中的方块, bDraw为1, 画上, bDraw为0, 抹去方块。
function DrawCurBox()
{
local i j t bDraw sBox s
bDraw=

s=""
if (( bDraw == 0 ))
then
sBox=""
else
sBox=""
s=$s"})))
#=$
done


#显示当前移动的方块
if (( $ == 8 ))
then
#计算当前方块该从顶端哪一行"冒"出来
for ((j = 0, t = 4; j < 8; j = 2))
do
if (($ < t)); then t=$; fi
done
((boxCurY = -t))
for ((j = 1, i = -4, t = 20; j < 8; j = 2))
do
if (($ > i)); then i=$; fi
if (($ < t)); then t=$; fi
done
((boxCurX = (iTrayWidth - 1 - i - t) / 2))

#显示当前移动的方块
echo -ne `DrawCurBox 1`

#如果方块一出来就没处放，Game over!
if ! BoxMove $boxCurY $boxCurX
then
kill -$sigExit $
ShowExit
fi
fi



#清除右边预显示的方块
for ((j = 0; j < 4; j ))
do
((i = iTop 1 j))
((t = iLeft 2 * iTrayWidth 7))
echo -ne "=$;
done

((cBoxNew = ${colorTable}))

#显示右边预显示的方块
echo -ne "}))
echo -ne ""
done
echo -ne "]
then
bash --show& #以参数--show将本程序再运行一遍
RunAsKeyReceiver $! #以上一行产生的进程的进程号作为参数
exit
else
#当发现具有参数--show时，运行显示函数
RunAsDisplayer
exit
fi 
