import numpy as np
import pandas as pd
import tensorflow as tf
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix, classification_report

def validate_model(model_path, validation_data, true_labels):
    # Load TFLite model
    interpreter = tf.lite.Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    
    # Get input and output tensors
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    # Run validation
    predictions = []
    for sample in validation_data:
        interpreter.set_tensor(input_details[0]['index'], np.array([sample], dtype=np.float32))
        interpreter.invoke()
        output = interpreter.get_tensor(output_details[0]['index'])
        predictions.append(1 if output[0][0] > 0.5 else 0)
    
    # Print validation metrics
    print(classification_report(true_labels, predictions))
    
    # Plot confusion matrix
    cm = confusion_matrix(true_labels, predictions)
    plt.figure(figsize=(8, 6))
    plt.imshow(cm, interpolation='nearest', cmap=plt.cm.Blues)
    plt.title('Confusion Matrix')
    plt.colorbar()
    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.show()
