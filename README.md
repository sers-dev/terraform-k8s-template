# Terraform K8S Template

This module simplifies the setup of terraform deployments on Kubernetes. It integrates all the common best practices when deploying on Kubernetes with terraform.

It is recommended to use the `instance` and `module` in the `./example` directory as base for any created modules and resulting instances. An example implementation deploying ubuntu can be found in `test/`

## Quickstart

```
kubectl create ns tf-state
cd ./test/ubuntu/instances/test/
terraform init
terraform apply
```

## FAQ

#### Why not just remove the `submodule` dir from `./example` and `./test`? It looks like a redundancy which creates unnecessary overhead

It is true that the `submodule` would not be required said examples, but it is done this way for the sake of consistency.

If you think about a micro-service architecture where multiple resources have to work together to build the actual application, it quickly makes sense to have this submodule abstraction between them. A good example for such an application would be `metallb`. 

Keeping this consistency abstraction even if it seems redundant gives us two things. First it will ensure that all modules are built exactly the same way, which makes working with multiple modules easy. Second it enables us to easily adjust if the software is split into multiple parts at any point in time. Alternatively there might be something external that you might want to deploy together with the application later down the road. A prometheus-exporter for example.

#### Why use this module if I can just write out each module as I built them?

I thought so too, when I first started writing terraform modules for Kubernetes in late 2019. With time I wrote more than 50 private modules containing everything I host on kubernetes. Relatively soonish it became clear I needed a kind of template from where I can draft new modules quicker that apply some best practices. The initial template can be found [here](https://github.com/Bobonium/kubernetes-terraform).

And even though that module worked for me, because I built it, I came to the conclusion that other people I shared this with had problems. These problems came from either not knowing enough Kubernetes or terraform and always boiled down to people not knowing that they'd need to adjust within the template to make it work for them.

Another Inconvenience I went through multiple times were instances where I'd had to make minor adjustments later on. I deployed Alertmanager initially as a Statefulset to setup the Clustering, but later learned I can do the same thing through a Deployment and a headless Serivce. Switching stuff after the old template was configured was always a lot of work. Same problem also occured if you configured something as a ConfigVolume only to realize later down the road it needs a password in the file and should be a secret instead.

This template fixes all these problems. There's nothing that needs to be deleted. You only configure everything by searching through the `replaceMe` strings of the example and you'll have a basic setup running. If you need some more uncommon adjustments like running in privileged you can also configure this, but everything comes pre-configured with sane defaults.

Need to swap a ConfigMap with a Secret? Simply move the map from `configVolumes` to `secretVolumes`! Realized that you can switch to a `Deployment` from the current `Daemonset` or `Statefulset`? Just replace the string in `podResourceType`

#### Why have a separate `instance`

You can think of the module as a general configuration for something that you want to have deployed. It defines everything that this Resource will always require. Either in your own specific context, or in a general approach suitable for everyone else on the Internet.

The `instance` splits the generic configuration from the configuration that needs to be done per actual environment. 

A good example for that would be prometheus. In a general sense you could probably define in the prometheus module, that the persistent storage is always located at `/prometheus`. There's no sense in letting any user define this ever. In your companies context it might even make sense to predefine the scrape config to scrape everything within the Kubernetes cluster, so that a specific team that deploys your module can't misconfigure the scrapeconfig. But nonetheless your teams could have data that they want to scrape outside of Kubernetes and need to be able to add additional scrape configs.

In this example the persistent path and the in cluster scrape config would be part of the prometheus module, but the additional scrape config could be supplied on an instance level through a variable, so that they can be adjusted as necessary.

#### But why is `instance` not simply a different workspace

Personally I see quite a few problems with workspaces in terraform, but you do you. If you're working with workspaces they need to be in the same repo. If you keep them like shown here, you can split them into more repos. This way a team can have all their instances in one repo, or even split them into one per instance. You also don't need to juggle with selecting the correct workspace and injecting the correct variables.

#### How to manage sensitive data?

If you can, simply autogenerate it as part of the terraform code. If you need them from external sources, inject them as you'd normally do for any other terraform code with `-var` in your pipeline or read them from the outputs of other terraform states as part of your instance
