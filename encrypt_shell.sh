#!/bin/bash

echo "start encrypt..."

enc_file=./key/enc_public.key
sig_file=./key/sig_private.key
if [ ! -f $enc_file ] || [ ! -f $sig_file ]; then
    echo "encrypt and signature key files are not found, exit..."
    exit 1
fi

if [ -z $1 ]; then
    echo "input encrypt type [cmd|sn], exit..."
    exit 1
fi

intype=$1
if [ "$intype" = "sn" ]; then
    if [ -z $2 ] || [ -z $3 ]; then
        echo "input serial number and script file first, exit..."
        exit 1
    fi

    serial=$2
    file=$3

    # check the input serial number
    # FFB2 - old version
    # FFBD - luxurious version
    # FFBE - simple version
    if [[ ! $serial =~ FFB[2DE]US[M-Z][1-9X-Z][1-9A-V]([0-9]{4}) ]]; then
        echo "invalid input serial number, exit..."
        exit 1
    fi

    # check the input file
    if [ ! -f $file ]; then
        echo " script file [$file] is not found, exit..."
        exit 1
    fi

    output_file=$serial
    input_file=$file
    middle_file=$file-mid

    # delete the origin data
    rm -rf $output_file*

    # save flag
    cp -f $input_file $middle_file
    echo "#$serial" >> $middle_file
else
    if [ -z $2 ]; then
        echo "invalid command parameter, exit..."
        exit 1
    fi

    cmd=$2
    output_file=command
    middle_file=$output_file-mid

    # delete the origin data
    rm -rf $output_file*

    echo $cmd > $middle_file
fi

# encrypt the origin file
openssl rsautl -encrypt -inkey $enc_file -pubin -in $middle_file -out ${output_file}.enc

# signatrue the encrypt file
openssl dgst -sha256 -out ${output_file}.sig -sign $sig_file -keyform PEM ${output_file}.enc

# package
tar czf ${output_file}.tar.gz ${output_file}.enc ${output_file}.sig

rm -rf $middle_file ${output_file}.enc ${output_file}.sig
echo "encrypt success -> ${output_file}.tar.gz"
