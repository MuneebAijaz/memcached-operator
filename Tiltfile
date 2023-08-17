allow_k8s_contexts('default/api-om-sno1-lcaas-lab-kubeapp-cloud:6443/kube:admin')
load('ext://restart_process', 'docker_build_with_restart')
# load("ext://local", "local")



# def printMetadata():
#     print("{a}  Operator Local Development with Tilt  {b}".format(1, a="*"*10, b="*"*10))
#     local("echo K8s Current Context :: $(kubectl config current-context)", quiet=False, echo_off=True)
#     local("echo  Current Namespace :: $(kubectl config view --minify -o jsonpath='{..namespace}')", quiet=False, echo_off=True)
#     local("echo GO Version :: $(go version | cut -d' ' -f3)", quiet=False, echo_off=True)
#     local('echo Operator SDK Version :: $(operator-sdk version | cut -d\\\" -f2)', quiet=False, echo_off=True)
#     print("{a}".format(1, a="*"*60))
# printMetadata()


local_resource("Make Generate&Manifests", "make generate manifests")


def makeDeploy():
    local_resource("Make Deploy", "echo deploy")
    install = kustomize('config/default')
    objects = decode_yaml_stream(install)
    for o in objects:
        if o.get('kind') == 'Deployment' and o.get('metadata').get('name') == "memcached-operator-controller-manager":
            img=o["spec"]["template"]["spec"]["containers"][1]["image"]
            newImage="localhost:5001/{1}".format(1, img)
            o["spec"]["template"]["spec"]["containers"][1]["image"] = newImage
            print(newImage)
            o['spec']['template']['spec']['securityContext']['runAsNonRoot'] = False
    updated_install = encode_yaml_stream(objects)
    k8s_yaml(updated_install)
    


local_resource("BuildManager", 
                "CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o bin/manager main.go",
                deps=[
                    "main.go",
                    "go.mod",
                    "go.sum",
                    "api",
                    "controllers",
                ])


# docker_build(
#   'localhost:5001/controller:latest',
#   '.',
#   entrypoint=['/manager'],
#   dockerfile='Dockerfile',
#   only=[
#     "./main.go",
#     "./go.mod",
#     "./go.sum",
#     "./api",
#     "./controllers",
#   ]
# )


docker_build_with_restart(
  'localhost:5001/controller:latest',
  '.',
  entrypoint=['/manager'],
  dockerfile='tilt.Dockerfile',
  only=[
    "./main.go",
    "./go.mod",
    "./go.sum",
    "./api",
    "./controllers",
    # './bin',
  ],
  live_update=[
    sync('./bin/manager', '/manager'),
  ],
)

# docker_build_with_restart(
#   'localhost:5001/controller:latest',
#   '.',
#   entrypoint=['/manager'],
#   dockerfile='tilt.Dockerfile',
#   only=[
#     "./main.go",
#     "./go.mod",
#     "./go.sum",
#     "./api",
#     "./controllers",
#     # './bin',
#   ],
#   live_update=[
#     sync('./bin/manager', '/manager'),
#   ],
# )


# local_resource("Delete Samples", "kubectl delete -f config/samples/cache_v1alpha1_memcached.yaml", trigger_mode=TRIGGER_MODE_MANUAL)
# local_resource("Apply Samples", "kubectl apply -f config/samples/cache_v1alpha1_memcached.yaml", trigger_mode=TRIGGER_MODE_MANUAL)
# local_resource("Get Memcacheds", "kubectl get memcacheds -A", trigger_mode=TRIGGER_MODE_MANUAL)
# local_resource("Delete Memcacheds Deployment", "kubectl delete deploy memcached-operator-controller-manager -n memcached-operator-system", trigger_mode=TRIGGER_MODE_MANUAL)


tiltfile_path = config.main_path
if config.tilt_subcommand == 'up':
    print("{a}  Operator Local Development with Tilt  {b}".format(1, a="*"*10, b="*"*10))
    print("""
    \033[32m\033[32mKubernetes Operator Local Development with Tilt!\033[0m
    """)
    local("echo K8s Current Context :: $(kubectl config current-context)", quiet=False, echo_off=True)
    local("echo  Current Namespace :: $(kubectl config view --minify -o jsonpath='{..namespace}')", quiet=False, echo_off=True)
    local("echo GO Version :: $(go version | cut -d' ' -f3)", quiet=False, echo_off=True)
    local('echo Operator SDK Version :: $(operator-sdk version | cut -d\\\" -f2)', quiet=False, echo_off=True)
    print("{a}".format(1, a="*"*60))
    makeDeploy()
if config.tilt_subcommand == 'down':
    print("Tilt Down ...")

