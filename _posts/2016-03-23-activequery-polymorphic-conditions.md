---
layout: post
title:  "ActiveQuery Polymorphic Conditions"
date:   2016-03-23 09:47:20 -0500
categories: activerecprd rails
author: peter
---

I came across some weird behavior yesterday in a Rails app where we were querying records where a polymorphic relationship _excluded_ a particular instance.

Specifically, we have a model for transactions, which have a related `source`, which can either be an `Order` or a `CreditSource`, and we wanted to find all transactions by a user that didn't not have a specific order instance as its `source`.

Easy, right?

{% highlight ruby %}
user.transactions.where.not(source: order) #bad
{% endhighlight %}

Turns out ActiveQuery interprets that in a not so useful way:

{% highlight bash %}
> puts user.transactions.where.not(source: CreditSource.first).to_sql
SELECT "transactions".* FROM "transactions" WHERE "transactions"."user_id" = 1 AND ("transactions"."source_type" != 'Order') AND ("transactions"."source_id" != 1)
{% endhighlight %}

This means that Active Query was fetching all of the user's transactions where the source type was not order and the source ID was not 1, ie all credit sources that did not have ID 1, ie, meaningless.

What we really wanted was something more like this:

{% highlight sql %}
SELECT transactions.*
FROM transactions
WHERE transactions.user_id = 1
AND NOT(transactions.source_type = 'Order' AND transactions.source_id = 1);
{% endhighlight %}

Or, alternatively:

{% highlight sql %}
SELECT transactions.*
FROM transactions
WHERE transactions.user_id = 1
AND transactions.source_type != 'Order' OR transactions.source_id != 1;
{% endhighlight %}

This means find all of the user's transactions where the source type is a credit source, or, if it's not a credit source (ie is an order), then exclude cases where its ID is 1.

Either of these will do the trick:

{% highlight bash %}
> puts user.transactions.where.not('source_type = ? and source_id = ?', 'Order', 1).to_sql
SELECT "transactions".* FROM "transactions" WHERE "transactions"."user_id" = 1 AND NOT ("transactions"."source_type" = 'Order') AND ("transactions"."source_id" = 1)
> puts user.credit_histories.where('source_type != ? or source_id != ?', 'Order', 1).to_sql
SELECT "transactions".* FROM "transactions" WHERE "transactions"."user_id" = 1 AND ("transactions"."source_type" != 'Order' OR "transactions"."source_id" != 1)
{% endhighlight %}

[jekyll-docs]: http://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
