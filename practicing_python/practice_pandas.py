import pandas as pd
import numpy as np

exam1 = pd.read_csv('data/연습문제/Car93.csv')


def example1_pd():
    wheelbase = exam1['Wheelbase']
    wheelbase_avg = wheelbase.mean()
    wheelbase_sd = wheelbase.std()

    # case1
    low_1 = wheelbase_avg - wheelbase_sd*1.5
    high_1 = wheelbase_avg + wheelbase_sd*1.5

    average_1 = wheelbase[(wheelbase > low_1 & wheelbase < high_1)].mean()

    # case2
    low_2 = wheelbase_avg - wheelbase_sd*2
    high_2 = wheelbase_avg + wheelbase_sd*2

    average_2 = wheelbase[(wheelbase > low_2 & wheelbase < high_2)].mean()

    # case3
    low_3 = wheelbase_avg - wheelbase_sd * 2.5
    high_3 = wheelbase_avg + wheelbase_sd * 2.5

    average_3 = wheelbase[(wheelbase > low_3 & wheelbase < high_3)].mean()

    case1 = average_1 - wheelbase_avg
    case2 = average_2 - wheelbase_avg
    case3 = average_3 - wheelbase_avg

    result = round(case1+case2+case3, 4)

    return result


def example2_pd():
    exam2 = pd.read_csv('data/연습문제/Car93.csv')
    rank = exam2['Length'].rank(method='average')
    sub = exam2['Length'][rank <= 30]
    sub_std = sub.std()
    result = round(sub_std, 3)
    print(result)


def example3_pd():
    exam3 = pd.read_csv('data/연습문제/Car93.csv')
    max_price_sort = exam3['Max_Price'].sort_values(ascending=False, ignore_index=True)
    min_price_sort = exam3['Min_Price'].sort_values(ignore_index=True)
    diff = max_price_sort - min_price_sort
    diff_sd = diff.std()
    result = round(diff_sd, 3)
    print(result)


def example4_pd():
    exam4 = pd.read_csv('data/연습문제/Car93.csv')
    weight = exam4['Weight']
    weight_std = (weight - min(weight))/(max(weight) - min(weight))

    var_under = weight_std[weight_std < 0.5].var()

    var_over = weight_std[weight_std > 0.5].var()

    result = abs(var_over - var_under)

    result = round(result, 3)

    print(result)


def example5_pd():
    exam5 = pd.read_csv('data/연습문제/Car93.csv')
    uniq_raw = exam5[['Manufacturer', 'Origin']].drop_duplicates()
    num_uniq_raw = uniq_raw.shape[0]
    exam5['sub_str'] = exam5['Manufacturer'].str[:2]
    uniq_new = exam5['sub_str', 'Origin'].drop_duplicates()
    result = num_uniq_raw - uniq_new

    print(result)


def example6_pd():
    exam6 = pd.read_csv('data/연습문제/Car93.csv')
    count_rpm_gp = exam6.groupby(['Type', 'Man_trans_avail'])['RPM'].count()
    sum_rpm_gp = exam6.groupby(['Type', 'Man_trans_avail'])['RPM'].sum()
    median_rpm_gp = exam6.groupby(['Type', 'Man_trans_avail'])['RPM'].median()
    result = round(sum(median_rpm_gp - sum_rpm_gp/count_rpm_gp), 0)

    print(result)


def example7_pd():
    exam7 = pd.read_csv('data/연습문제/Car93.csv')

    avg = exam7['RPM'].mean()
    exam7['RPM'] = exam7['RPM'].filna(avg)
    rpm_std = (exam7['RPM'] - exam7['RPM'].mean())/exam7['RPM'].std()
    wheelbase_std = (exam7['Wheelbase'] - exam7['Wheelbase'].mean())/exam7['Wheelbase'].std()
    diff = wheelbase_std*(-36) - rpm_std
    diff_sd = diff.std()
    result = round(diff_sd, 3)

    print(result)


def example8_pd():
    exam8 = pd.read_csv('data/연습문제/Car93.csv')
    df_case1 = exam8.copy()
    df_case2 = exam8.copy()
    avg_price = exam8['Price'].mean()
    df_case1['Price'] = exam8['Price'].filna(avg_price)
    avg_maxmin = df_case1[['Max_Price', 'Min_Price']].mean(axis=1)
    sub_df_case1 = df_case1[df_case1['Price'] < avg_maxmin]
    sum_case1 = sub_df_case1.groupby('Origin')['Price'].sum()
    med_price = exam8['Price'].median()
    df_case2['Price'] = df_case2['Price'].fillna(med_price)
    q3 = df_case2['Min_Price'].quantile(.75)
    sub_df_case2 = df_case2[df_case2['Price'] < q3]
    sum_case2 = sub_df_case2.groupby('Origin')['Price'].sum()

    max_value = max(sum_case1+sum_case2)
    result = int(np.floor(max_value))

    print(result)


def example9_pd():
    exam9 = pd.read_csv('Car93.csv')
    price = exam9['Price'].copy()
    max_price = exam9['Max.Price'].copy()
    min_price = exam9['Min.Price'].copy()
    type = exam9['Type'].copy()

    cond_na = price.isna()
    price[cond_na] = (max_price[cond_na]+min_price[cond_na])/2

    cond1 = price < 14.7
    cond2 = (price > 25.3) & (type == 'Large')
    cond = cond1 | cond2

    result = exam9[cond].shape[0]

    print(result)


def example10_pd():
    exam10 = pd.read_csv('Car93.csv')
    make = exam10['Make'].copy()
    airbag = exam10['AirBags'].copy()

    make = make.str.strip()
    make_sub = make.str.startwith(('Chevrolet', 'Pontiac', 'Hyundai'))

    cond = (airbag == 'Driver only')

    result = sum(cond & make_sub)

    print(result)







