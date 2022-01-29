locals {
  horizontalPodAutoscaler = {
    enabled = false
    behavior = {
      scaleUp = {
        selectPolicy               = "Max"
        stabilizationWindowSeconds = 300
        policies = [
          {
            type          = "Percent"
            value         = "100"
            periodSeconds = 15
          }
        ]
      }
      scaleDown = {
        selectPolicy               = "Min"
        stabilizationWindowSeconds = 300
        policies = [
          {
            type          = "Percent"
            value         = "25"
            periodSeconds = 60
          }
        ]
      }
    }
    metrics = [
      {
        type            = "Resource"
        name            = "cpu"
        describedObject = null
        metric          = null
        target = {
          type               = "Utilization"
          averageValue       = 0
          averageUtilization = 80
          value              = null
        }
      }
    ]
  }
}