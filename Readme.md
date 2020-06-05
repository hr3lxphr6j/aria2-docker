# aria2 + AriaNG docker image

[aria2](https://github.com/aria2/aria2) + [AriaNg](https://github.com/mayswind/AriaNg) 整合镜像

## 特性

- 单容器包含 [aria2](https://github.com/aria2/aria2) 和 [AriaNg](https://github.com/mayswind/AriaNg)
- 只监听一个端口，反代aria2 jsonRPC
- 多架构支持，可在树莓派等设备上使用
    - `linux/386`
    - `linux/amd64`
    - `linux/arm/v6`
    - `linux/arm/v7`
    - `linux/arm64`
    - `linux/ppc64le`
    - `linux/s390x`
- 基于`alpine`制作，image大小仅为26M

## 使用

- Step 1

    ```shell
    docker run -d -p <监听接口>:80 -v <下载路径>:/downloads --restart=always --name=aria2 chigusa/aria2:latest
    ```
    
- Step 2

    打开`http://127.0.0.1:<监听接口>`，更改jsonRPC端口为`<监听接口>`，刷新页面即可
    ![](https://i.imgur.com/EJPr5ER.png)

## 清理
    
```shell
docker rm -f aria2 && docker rmi chigusa/aria2:latest
```
