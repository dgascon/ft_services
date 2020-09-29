apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 128Mi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: PWD/mysql
  persistentVolumeReclaimPolicy: Retain
  claimRef:
    namespace: default
    name: mysql-pvc