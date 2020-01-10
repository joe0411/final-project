# final-project 接住掉落物(未完成)
作者:107321036 107321020

## Input/Output unit 輸入輸出元件
    1.8x8 LED 矩陣(顯示位置,掉落物)
    2.七段顯示器(計算得分數量)
    3.4 Bit Switch(控制位置)
    4.16 LED (計算miss數)
    
## 基本功能
    1.角色(綠色LED)按壓時會出現
    2.有掉落物(紅色LED)落下-----(X)
    3.吃到掉落物會累計(由七段顯示器顯示)------(X)
    4.生命制(由LED顯示)
    5.miss3次時遊戲結束(出現X畫面)
## 程式說明
### output
    output reg [7:0] DATA_R, DATA_G, DATA_B---> 接到 8x8 LED
    output reg  [2:0] Life ---> 接到 16 LED 燈
    output reg [2:0] COMM -------> 接到 8x8 LED 矩陣的 S2~S0 
    output reg [1:0] COMM_CLK -------> 7段顯示器 輸出位元
    output reg [6:0] d7_1 -------> 接到 7段顯示器
    output reg EN ----------> 接到 8X8 LED Enable
### input
    input CLK -------------------> FPGA 上 pin 22 為 50MHz 的 CLK 不必接線 
    input ip0, ip1, ip2, ip3 ------------> 接到 4 bits Switch
    input clear -------> 接到指撥開關
### 未來展望
    1.使遊戲能正常運作
    2.解決掉落物問題
