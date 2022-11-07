import numpy as np
import tensorflow as tf
from keras.applications import VGG16
from keras.applications.vgg16 import preprocess_input
from sklearn.model_selection import train_test_split
from keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout
from keras.models import Sequential
from example1_using_keras import make_training_and_validation_losses_plot
import pandas as pd
from skimage import io


def vgg16():
    vgg16_model = VGG16(weights='imagenet', include_top=False, input_shape=(300, 300, 3))
    return vgg16_model


class VariationVgg:
    def __init__(self, vgg16_model):
        self.vgg16_model = vgg16_model
        self.x5_vgg16 = []
        self.y5 = []

    def basic_4d(self, x, y):
        for i in range(len(x)):
            img = x[i]
            img = preprocess_input(img.reshape(1, 32, 32, 3))
            img_new = self.vgg16_model.predict(img)
            self.x5_vgg16.append(img_new)
            img_label = np.where(y[i] == 'male', 1, 0)
            self.y5.append(img_label)
            x5_vgg16 = np.array(self.x5_vgg16)
            print(x5_vgg16.shape)
            x5_vgg16 = x5_vgg16.reshape(x5_vgg16.shape[0], x5_vgg16.shape[2], x5_vgg16.shape[3], x5_vgg16.shape[4])
            y5 = np.array(self.y5)
            return x5_vgg16, y5

    # def basic_5d(self):


def mlp_used_model(num_features, num_classes):
    mlp_model = Sequential()
    mlp_model.add(tf.keras.layers.Dense(256, input_dim=num_features))
    mlp_model.add(tf.keras.layers.Dense(256, activation='relu'))
    mlp_model.add(tf.keras.layers.Dropout(0.45))
    mlp_model.add(tf.keras.layers.Dense(256, activation='relu'))
    mlp_model.add(tf.keras.layers.Dense(num_classes, activation='softmax'))

    mlp_model.compile(optimizer='sgd', loss='mae', metrics=['accuracy'])
    return mlp_model


def cnn_used_model(shape1, shape2, shape3, repeat_pooling=1):
    input_shape = (shape1, shape2, shape3)
    kernel_size = 3
    pool_size = (2, 2)
    filters = 64
    dropout = 0.5
    cnn_model = Sequential()
    cnn_model.add(Conv2D(filters=filters, kernel_size=kernel_size,
                         activation='relu', input_shape=input_shape))
    count_pooling_times = 0
    while count_pooling_times < repeat_pooling:
        cnn_model.add(MaxPooling2D(pool_size))
        cnn_model.add(Conv2D(filters=filters, kernel_size=kernel_size, activation='relu'))
        count_pooling_times += 1
    cnn_model.add(Flatten())
    cnn_model.add(Dense(512, activation='relu'))
    cnn_model.add(Dropout(0.5))
    cnn_model.add(Dropout(dropout))
    cnn_model.add(Dense(1, activation='sigmoid'))
    cnn_model.summary()
    cnn_model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
    return cnn_model


def pull_gender_picture_dataset_and_renewal():
    data = pd.read_csv('통계학과딥러닝PBL_과제자료.csv')
    data_male = data[data['please_select_the_gender_of_the_person_in_the_picture'] == 'male']
    data_female = data[data['please_select_the_gender_of_the_person_in_the_picture'] == 'female']
    final_data = pd.concat([data_male[:1000], data_female[:1000]], axis=0).reset_index(drop=True)

    return final_data


def main():
    data = pull_gender_picture_dataset_and_renewal()
    print('successfully imported data')
    x = []
    y = []
    for i in range(data.shape[0]):
        try:
            image = io.imread(data.loc[i]['image_url'])
            if image.shape == (300, 300, 3):
                x.append(image)
                y.append(data.loc[i]['please_select_the_gender_of_the_person_in_the_picture'])
        except:
            continue
    print('made x, y')

    model = vgg16()
    print('pulled successfully')

    selected_x, selected_y = VariationVgg.basic_4d(model, x, y)

    x_train, x_test, y_train, y_test = train_test_split(selected_x, selected_y, test_size=0.1, random_state=1,
                                                        stratify=selected_y)
    # model_cnn_vgg16 = cnn_used_model(x_train.shape[1], x_train.shape[2], x_train.shape[3])
    model_mlp_vgg16 = mlp_used_model(784, y_train.shape[1])

    history_vgg16 = model_mlp_vgg16.fit(x_train/np.max(x_train), y_train, batch_size=32, epochs=20,
                                        validation_data=(x_test/np.max(x_train), y_test))

    make_training_and_validation_losses_plot(history_vgg16)


if __name__ == '__main__':
    main()
