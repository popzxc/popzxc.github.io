+++
title = "Code reviews are not a bottleneck"
date = 2026-09-21
description = "Thoughs about the global desire to 'optimize away' code reviews"
+++

Lately, the internet is booming with statements like "LLMs are now doing everything, so code reviews are now the bottleneck" with various ideas on how to make this process faster/simpler or remove it altogether.

And this always sounds weird to me. These people seem to be using code reviews now, and they seem to realize that just allowing LLMs merging to main could not be the best idea, so... Why? Why do they want to get rid of the last bastion of human effort in the development process?

Here are some examples: [PostHog](https://newsletter.posthog.com/p/code-review-tips), [Intercom](https://www.intercom.com/blog/ai-is-approving-our-pull-requests-heres-how-we-made-it-safe/), [Anthropic](https://claude.com/blog/code-review), [Kaxil Naik](https://x.com/kaxil/status/2037503513350005134), thousands of them. [Boris Cherny gives code reviews 6-12 more months](https://x.com/bcherny/status/2098229124024397911).

> Note:
>
> Context alignment: this post is about possibility of eliminating/minimizing code reviews as a form of human activity. It is not about AI bad/AI good. It is not about whether each person in each team must review each pull request. It is about the prospects of eliminating the process as an _industry development norm_.
>
> PostHog article opens with "The 500 IQ take is for developers to review as little code as possible.". That's the angle we're talking about.

The resources suggesting solutions to the "problem" seems to focus on having agents review the code instead of you. Which is certainaly I'd expect Anthropic to promote, since it boosts their revenue. But everyone else?

Sometimes, the claims in such posts are just weird. Like "If a change is too big, too complex, or too broad in scope, it flags it and requires it to be broken down" -- if your goal is to not look at the code, why would you care? Big PRs are considered bad practice because they are hard to review _for people_. If anything, agents likely will do better with a bigger PR implementing a _single complex change_ than with N smaller PRs _implementing the same single complex change_, because they then will review each PR in isolation, losing the context of the overall goal. This sounds like cargo cult: "we will ask agents do code reviews like humans did them, without thinking what makes more sense".

The conclusions are wild as well: "Our goal was to remove a bottleneck that, if left unchecked, risked pushing engineers towards rubber-stamping reviews under time pressure.". So... if you generate too much code to handle, the conclusion is to remove humans from the loop rather than to lower expectations?

Similarly, "The context switching that comes with agentic coding is exhausting. One easy way to reduce that fatigue is by automating code review-adjacent tasks that don’t need your attention." -- I see the same problem. You try to increase velocity beyond the _processing_ speed of your team. Isn't the paradox obvious here?

All of that seems to be based on a very wrong premise: code reviews is primarily a mean of establishing the code _correctness_. So let's talk about them.

Disclaimer: I am no LLM hater. If anything, I use LLMs very extensively, but I still consider them to be a tool rather than a brain replacement. I do find the current trends of the frontier LLM adoptions annoying and harmful though.

## The team needs to own the code

The software engineering team typically _owns_ some codebase. What does _ownership_ means here?
Likely, things like this:
- Ability to reason about the limits of the architecture and thus match business expectations to actual capabilities.
- Ability to manage technical debt: increase it to speed up the delivery, and work on reducing to offset the baseline maintenance cost.
- Ability to operate the codebase in a production environment: once the team ships a release, it keeps being responsible for it.

None of these are defined in terms of "code maintainability" or other abstract metrics, they all directly translate to the things businesses seem to care about.

But the _means_ to achieve this structure of ownership is typically through _understanding of the codebase_.
When the team lead gets a request to "add this feature" and needs to provide the estimate, the thought process typically will go down to the code anyway:
- This feature affects a legacy module that wasn't refactored for a while, this will slow things down.
- The specification is not perfect and product doesn't seem to have full picture, likely we will need to iterate.
- The existing capabilities are similar to what we need, but not quite. We can either spend some time on refactoring to make it properly, or can hack things around this time if it's urgent. What's the priority?

An agent, no matter how you cook it, cannot think in these dimensions _in vacuum_. The LLMs are trained to do what they're asked for, so unless you _already_ have the knowledge required to answer the above questions, your question for the agent will likely just be "Can we build it?", and the answer is guaranteed to be "Sure we can!". LLM-based research exist, but it is not the point of this post. We're talking about code reviews, e.g. completed features.

Attempting to add guardrails like "make sure the codebase is maintainable" or "do not introduce hacks" are akin to "make no mistakes": the definition of "maintainable" or "hacks" happens through the perception of codebase at hand. [FFmpeg](https://github.com/FFmpeg/FFmpeg) is certainly maintainable for its maintainers; everyone else likes to complain about it. And attempt to define "maintainable code" as a set of rules that is written once and then you never look at the code is likely to fail as well.

As a result, an _aggregated software team as a whole_ should have enough understanding of the codebase in order to be able to _predictably deliver business-requested changes_ long term. Short term it is less important and can be seen as "we'll ship whatever at cost of increasing the technical debt".

## But isn't technical debt a thing of the past?

That's a good question. Previously, working on a legacy system was a PITA, it was slow, and everyone was unhappy that these damn managers won't allocate time to just refactor it.

Now you can just ask agent to go and do it. No legacy for you. Or even better: start a new greenfield project and replace the old system.

Development of new features is also not blocked at the cognitive complexity of the developer at hand. An agent _can_ understand whatever code you have. And it is not afraid of changing such code.

So no more technical debt, right?

Well, that's where the reality starts falling apart. The definition of done for the agent has to be a pass of the formal criteria. Which is why agents love adding tests for whatever they touch so much, whether it makes sense or not. It makes the behavior _fixed_ and creates a _feedback loop_ if any change had undesired side effects.

But if you have a legacy codebase at hand, the behavior is usually not fixed, it "just works". In order to change it, you will need to put in personal effort in understanding the _intent_ behind things and digging up _expected behavior_, something that agents struggle with to this day. Even if the codebase has really well test coverage, you are likely to end up with a different form of the same shape. Look at [any file in Bun's Rust rewrite](https://github.com/oven-sh/bun/blob/main/src/js_parser/scan/scan_imports.rs) that Anthropics spend $100k+ on (and keeps pouring the money in). Does that look like the codebase that became _better_ from unattended LLM involvement? It is an extreme example, but it is an important one because that's the code shape _implied_ by the people who see code reviews as a bottleneck.

One could ask: so what? If LLM handles the code, why would it matter how it looks?

And the answer gets us back to the previous chapter: to establish _code ownership_.

How would you know that LLM telling that feature is possible tells you the truth?

How would you make sure that the architecture is not full of branching parallel hierarchies of the same functionality?

How would you know that the agent itself starts to struggle with the codebase, and the percentage of poorly implemented features grows?

Typically, by being able to look at the code and map it onto your understanding of how the current generation of LLMs works. Even if you don't write code by hand anymore. And if you _can't_ look at the code and estimate how healthy it is, you might be in a big trouble, because changing things back might require _a lot_ of effort, and the business is already used to high feature velocity. Oops.

So the technical debt is still very real, and with higher velocity expectations the stakes for its management are higher as well.

## How do you keep knowing the codebase?

If "jesus take the wheel" approach no longer sounds as convincing, you might start worrying about the team keeping enough knowledge of the codebase. _Especially_ if your team is LLM-native.

Previously, this has been done by _writing_ code. You need to make changes, and thus you are forced to learn your surroundings. You might not know everything, but you know your corner. And if there are enough people in the team to cover all the corners, then collectively you can own this codebase. Ideally, you also have at least one person who looks at the codebase as a whole and maintains its _architecture_, preventing code duplication, ensuring module isolation, and all the other fancy nice things that make code development cheaper for the business long term.

But now that teams do not write code, how to maintain it? Well, the last measure that remains is to make people _read code_. And the more people read more code, the better it is for your team. There is a level of slack you can give here, e.g. as long as the module is isolated the code quality might become worse there at the moment, and later you'll get back to it. But it becomes increasingly more important to maintain these boundaries.

The code review value _today_ is maintaining the _knowledge_. And it's the kind of knowledge you really don't want to lose.

## It doesn't matter how good LLMs are

I intentionally refrain from claiming anything about the way LLMs write code. A year ago they were very bad at refactoring. Today, they are still bad, but if you are good at guiding them, you can get what you want. Context management becomes better. Harnesses become more powerful. Who knows what will be possible in a year.

What doesn't change, however, is that underspecified requests end up in underspecified results. If it _kinda_ does what you need, and the change _kinda_ looks like what you expected to see, these _kinda_ tend to accumulate. Reviewing agent will be able to find these _kinda_ if you will point it in this direction, but for that you still need to keep looking at the code and be able to at least formulate the feeling you have. Which is something that still requires someone to look at the code in the first place.

## But small PRs are fine!

Some of the articles argue that they automate merging of "simple" or "small" PRs, and delegate "more complex" things to humans.

But here's the problem: if the PR is really 100 loc of trivial code, it will take a human 2 minutes to look at it. Why not?

The problem arises if you either:
- Have dozens of small pull requests per day. These accumulate.
- Make agents break complex PRs down to "small and trivial" ones (which can be merged automatically).

Size of the PR is not a metric; the ratio between the speed of change of the _overall codebase_ and the speed of _processing_ such changes by the team is.

## Code reviews are not about correctness

And here we come to the main idea: code reviews are _not_ about the correctness. 
They're not about "making sure that the change makes sense" either.

People has written about this in pre-LLM era too ([1](https://neilmitchell.blogspot.com/2017/04/code-review-reviewed.html), [2](https://remysharp.com/2021/03/24/the-mythical-code-review), [3](https://softwareengineering.stackexchange.com/questions/255944/what-is-the-purpose-of-a-code-review), [4](https://blog.jetbrains.com/upsource/2017/03/14/code-review-for-knowledge-sharing?utm_source=chatgpt.com)).

All of them have the same general idea: code review exists for **knowledge sharing**.

It is a mean to make sure that your team (as a whole!) still understands what does your code do.
Which changed have occurred.
What direction are we moving in.

The rest -- finding out defects, disagreeing about the approach, proposing doing the same thing elsewhere, etc -- follows from it. There is an act of human looking at the code, understanding what's going on, and _optionally_ making any conclusions. Even if there are no conclusions at this given review, the act of review does not become useless.

Previously it was also a way to educate people on how to write code better. Now it's less relevant on its own (for the teams at which this post is targeted). However, you can still teach people about the _architecture_ and how to make sure that agentic output meets _human_ expectations, as opposed to lints and tests.

This is a part that cannot be automated. And it's not a bottleneck: it's a risk diversification mechanism that increases chances of your product survival in 1, 2, 5 years. It's a mean to keep _humans_ accountable for the products they develop. It's a way to make sure that your team is not just a bunch of meat proxies.

## So what, no LLM reviews?

LLM reviews can be great. Nobody argues that LLM can spot bugs now. If your team uses LLMs in the review process, it could be great.

Note that I don't argue that _each_ pull request has to be reviewed. I don't even argue that _pull requests_ per se must be reviewed. If your team allocates 20% of time to just reading the code in `main` and making sure that all is good, and you're consistent at it... Well, it's a weird setup, but whatever works for you. It's still a form of review.

The thing I'm arguing against is using LLMs to go beyond team capabilities. Because it means that the team loses ownership of the code, and eventually you end up at mercy of the LLM provider of choice.

Will it be able to handle your codebase next year when you'll need Feature #1? Will it be able to fix production when it's down after 5 years of such maintenance? Well, there is a way to find out.

## The last engineer

Now let's imagine: the bright future, coding is solved, reviews are not needed, and [even CI is no longer a bottleneck](https://claude.com/blog/agentic-coding-is-straining-ci-heres-how-we-scaled-test-impact-analysis-at-anthropic).

All the existing engineers are now goose farmers, universities do not teach CS (as if anyone would want to learn it anyways), and each IT company consists of a single non-technical CEO (what's _technical_ again?).

I... look forward to this day.
