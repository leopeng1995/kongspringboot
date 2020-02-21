## Kong、Spring和K8s集成

示例项目：通过Ingress访问服务A，服务A通过kong-proxy调用服务B。

https://github.com/leopeng1995/kong-springboot
服务A代码（K8s相关配置在config目录下）

https://github.com/leopeng1995/kong-springboot2
服务B代码

创建服务A的Deployment、Service：
config/kongspringboot-application-openshift.yaml


在Kong中创建服务A：
config/kongspringboot-ingress-openshift.yaml

创建服务B的Deployment、Service：
config/kongspringboot2-application-openshift.yaml

在Kong中创建服务B：
config/kongspringboot2-ingress-openshift.yaml

服务A调用服务B的代码片段：
```java
public class ApplicationController {
    @GetMapping("/private")
    public ResponseEntity<Order> getPrivateString(HttpServletRequest request) {
        RestTemplate rest = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();

        System.setProperty("sun.net.http.allowRestrictedHeaders", "true");
        headers.add("Host", "kong.springboot2");

        return rest.exchange("http://kong-proxy.kong-api.svc.cluster.local:80/api/order", HttpMethod.GET, new HttpEntity<Object>(headers), Order.class);
    }

}
```

```bash
# oc cluster up
# oc login -u system:admin
# oc new-project kong-api
# oc create —namespace kong-api -f postgres-openshift.yaml
# oc create —namespace kong-api -f kong-resources-openshift.yaml
# kubectl create -f kongspringboot-application-openshift.yaml
# kubectl create -f kongspringboot-ingress-openshift.yaml
# kubectl create -f kongspringboot2-application-openshift.yaml
# kubectl create -f kongspringboot2-ingress-openshift.yaml
# kubectl create -f kongadminapi-ingress-openshift.yaml
```

```bash
# oc get svc # 获取kong-proxy的IP和端口
# http ${PROXY_IP}:${HTTP_PORT} Host:kong-admin.api # 通过Ingress访问Kong Admin API
# http ${PROXY_IP}:${HTTP_PORT}/api/public Host:kong.springboot # 未调用服务B路径
# http ${PROXY_IP}:${HTTP_PORT}/api/private Host:kong.springboot # 调用服务B路径
```
