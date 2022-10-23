import keras.models
import numpy as np
import tensorflow as tf
import keras.datasets.mnist as mnist
import matplotlib.pyplot as plt
from keras.utils import to_categorical, plot_model
from keras.models import Sequential
from keras.layers import MaxPooling2D, Conv2D, Dropout, Flatten, Dense, SimpleRNN


def input_batch_and_epoch():
    batch_size = int(input('batch : '))
    epochs = int(input('epochs : '))
    return batch_size, epochs


# mlp = multi layer perception
def example_deep_learning_mlp(x_train, x_test, y_train, y_test, mlp_epoch, mlp_batch_size, num_features, num_classes):
    x_train = x_train.reshape(-1, num_features).astype('float32')
    x_test = x_test.reshape(-1, num_features).astype('float32')
    x_train = x_train / 255.
    x_test = x_test / 255.

    mlp_model = keras.models.Sequential()
    mlp_model.add(tf.keras.layers.Dense(256, input_dim=num_features))
    mlp_model.add(tf.keras.layers.Dense(256, activation='relu'))
    mlp_model.add(tf.keras.layers.Dropout(0.45))
    mlp_model.add(tf.keras.layers.Dense(256, activation='relu'))
    mlp_model.add(tf.keras.layers.Dense(num_classes, activation='softmax'))

    mlp_model.compile(optimizer='sgd', loss='mae', metrics=['accuracy'])

    print(mlp_model.summary())

    # TODO: pydot, graphviz 문제 해결해야 됨
    # plot_model(mlp_model, to_file='C:/Users/young/Desktop/2022_2학기/통계학과 딥러닝 PBL/저장된 자료/mlp.png', show_shapes=True)

    x_val = x_train[:10000]
    partial_x_train = x_train[10000:]
    y_val = y_train[:10000]
    partial_y_train = y_train[10000:]

    # 부분 추출 확인: 검증용
    print(partial_x_train.shape)
    print(partial_y_train.shape)

    mlp_model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    history = mlp_model.fit(partial_x_train, partial_y_train, epochs=mlp_epoch, batch_size=mlp_batch_size,
                            validation_data=(x_val, y_val))

    mean_on_train = x_train.mean(axis=0)
    std_on_train = x_train.std(axis=0)

    print('훈련 세트 정확도: ', mlp_model.evaluate(x_train, y_train))
    print('테스트 세트 정확도: ', mlp_model.evaluate(x_test, y_test))
    history_out = history.history
    history_out.keys()
    return history_out


def example_deep_learning_cnn(x_train, x_test, y_train, y_test, cnn_epoch, cnn_batch_size, num_labels):
    shape1 = x_train.shape[1]
    shape2 = x_train.shape[2]
    x_train = x_train.reshape(-1, shape1, shape2, 1).astype('float32')
    x_test = x_test.reshape(-1, shape1, shape2, 1).astype('float32')
    x_train = x_train / 255.
    x_test = x_test / 255.

    # 일련의 값들 설정
    input_shape = (shape1, shape2, 1)
    kernel_size = 3
    pool_size = 2
    filters = 64
    dropout = 0.3
    repeat_pooling = 2
    cnn_model = Sequential()
    cnn_model.add(Conv2D(filters=filters, kernel_size=kernel_size,
                         activation='relu', input_shape=input_shape))
    count_pooling_times = 0
    while count_pooling_times < repeat_pooling:
        cnn_model.add(MaxPooling2D(pool_size))
        cnn_model.add(tf.keras.layers.Conv2D(filters=filters, kernel_size=kernel_size,
                                             activation='relu'))
        count_pooling_times += 1

    cnn_model.add(Flatten())
    cnn_model.add(Dropout(dropout))
    cnn_model.add(Dense(num_labels, activation='softmax'))
    cnn_model.summary()

    # TODO: pydot, graphviz 문제 해결해야 됨
    # plot_model(mlp_model, to_file='C:/Users/young/Desktop/2022_2학기/통계학과 딥러닝 PBL/저장된 자료/cnn.png', show_shapes=True)

    cnn_model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    cnn_model.fit(x_train, y_train, epochs=cnn_epoch, batch_size=cnn_batch_size)

    print('훈련 세트 정확도: ', cnn_model.evaluate(x_train, y_train))
    print('테스트 세트 정확도: ', cnn_model.evaluate(x_test, y_test))


def example_deep_learning_simple_rnn(x_train, x_test, y_train, y_test, rnn_epoch, rnn_batch_size):
    shape1 = x_train.shape[1]
    shape2 = x_train.shape[2]
    x_train = x_train.reshape(-1, shape1, shape2, 1).astype('float32')
    x_test = x_test.reshape(-1, shape1, shape2, 1).astype('float32')
    x_train = x_train / 255.
    x_test = x_test / 255.
    input_shape1 = (shape1, shape2)

    rnn_model = Sequential()
    rnn_model.add(SimpleRNN(units=256, dropout=0.2, input_shape=input_shape1))
    rnn_model.add(Dense(10, activation='softmax'))
    rnn_model.summary()

    # 동일하지만 다른 형식: function API
    # input_data = tf.keras.layers.Input(shape=input_shape1)
    # learned_data = SimpleRNN(256, dropout=0.2)(input_data)
    # result_of_rnn = Dense(10, activation='softmax')(learned_data)
    # rnn_model = tf.keras.layers.Model(inputs=input_data, outputs=result_of_rnn)

    # TODO: pydot, graphviz 문제 해결해야 됨
    # plot_model(rnn_model, to_file='C:/Users/young/Desktop/2022_2학기/통계학과 딥러닝 PBL/저장된 자료/rnn.png', show_shapes=True)

    rnn_model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    rnn_model.fit(x_train, y_train, epochs=rnn_epoch, batch_size=rnn_batch_size)
    print('훈련 세트 정확도: ', rnn_model.evaluate(x_train, y_train))
    print('테스트 세트 정확도: ', rnn_model.evaluate(x_test, y_test))


def make_training_and_validation_losses_plot(history_out):
    loss = history_out['loss']
    loss_val = history_out['val_loss']
    accuracy = history_out['accuracy']
    accuracy_val = history_out['val_accuracy']
    plt.plot(loss, 'bo', label='training loss')
    plt.plot(loss_val, 'b', label='validation loss')
    plt.title('Training and validation losses')
    plt.xlabel('epochs')
    plt.ylabel('loss')
    plt.legend()
    plt.show()

    plt.clf()
    plt.plot(accuracy, 'bo', label='training loss')
    plt.plot(accuracy_val, 'b', label='validation loss')
    plt.title('Training and validation losses')
    plt.xlabel('epochs')
    plt.ylabel('loss')
    plt.legend()
    plt.show()


def main():
    (x_train, y_train), (x_test, y_test) = mnist.load_data()

    # 초기 데이터
    print('loading primary mnist dataset')
    print(x_train.shape)
    print(x_test.shape)
    print(y_train.shape)

    num_features = 784
    num_labels = len(np.unique(y_train))

    # 범주형 자료를 one-hot 벡터로 전환
    y_train = to_categorical(y_train)
    y_test = to_categorical(y_test)
    num_classes = y_train.shape[1]

    # y_train 값 확인
    print('추가된 y_train: ', y_train.shape)

    # batch_size, epoch = 64, 30
    batch_size, epoch = input_batch_and_epoch()
    # mlp 모형 적용
    history_out = example_deep_learning_mlp(x_train, x_test, y_train, y_test, epoch, batch_size,
                                            num_features, num_classes)
    make_training_and_validation_losses_plot(history_out)

    # cnn 모형 적용
    example_deep_learning_cnn(x_train, x_test, y_train, y_test, epoch, batch_size, num_labels)

    # simple rnn 모형 적용
    example_deep_learning_simple_rnn(x_train, x_test, y_train, y_test, epoch, batch_size)


if __name__ == '__main__':
    main()
