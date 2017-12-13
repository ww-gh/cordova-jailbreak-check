# cordova-jailbreak-check V1.0.2
自定义插件用于检测系统IOS是否越狱Android是否被Root；

## 1、添加插件方式：
- 直接通过 url 安装：
```shell
cordova plugin add https://github.com/ww-gh/cordova-jailbreak-check.git
```
- 或通过 Cordova Plugins 安装，要求 Cordova CLI 5.0+：
```shell
cordova plugin add cordova-jailbreak-check
```

## 2、使用说明：
- typescript语法
```typescript ionic3
//检查是否越狱
this.platform.ready().then(() => {
        if (typeof cordova !== 'undefined' && cordova.plugins.JailBreakCheck) {
            cordova.plugins.JailBreakCheck.isJailBreak((value)=> {
                if (value === 'true') {
                    this.utils.showAlert((this.platform.is('android') ? "当前系统已被Root" : "当前系统已越狱") + "，请谨慎使用!");
                }
            });
        }
    }
);
```
- javascript语法
```javascript
//检查是否越狱
 cordova.plugins.JailBreakCheck.isJailBreak(function(value){
    if (value === 'true') {
        console.log("当前系统已被Root或已越狱，请谨慎使用!");
    }
});
```

## Support
- 邮箱：(wangwenxy@163.com)
- [故障反馈地址：](https://github.com/ww-gh/cordova-jailbreak-check/issues)
