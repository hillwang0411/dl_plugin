import tensorflow as tf

with tf.device("/DLGPU:0"):
    a = tf.constant(0)
    b = tf.constant(1)
    c = a + b
    print(c)
