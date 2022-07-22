// Copyright (c) 2011-2014 The Bitcoin Core developers
// Copyright (c) 2017-2019 The Raven Core developers
// Copyright (c) 2020-2021 The Kawkaw Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef KAWKAW_QT_KAWKAWADDRESSVALIDATOR_H
#define KAWKAW_QT_KAWKAWADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class KawkawAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit KawkawAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

/** kawkaw address widget validator, checks for a valid kawkaw address.
 */
class KawkawAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit KawkawAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

#endif // KAWKAW_QT_KAWKAWADDRESSVALIDATOR_H
