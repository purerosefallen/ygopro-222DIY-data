--超越者 废铁狮子
local m=80000013
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=80000001
cm.afkind=1--jiexi
cm.is_named_with_yvwan=1
cm.can_exchange=1
xpcall(function() require("expansions/script/c80000000") end,function() require("script/c80000000") end)
function cm.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
    --summon exchange
    Sym.yuwancf1(c) 
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.activate)
    c:RegisterEffect(e2)    
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil)
    if g:GetCount()<1 or not Duel.IsPlayerCanDraw(tp) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local gc=g:Select(tp,1,1,nil)
    local c=gc:GetFirst()
    Duel.SendtoDeck(c,tp,2,REASON_EFFECT)
    if not c:IsLocation(LOCATION_DECK) then return end
    Duel.ShuffleDeck(tp)
    c:ReverseInDeck()
    --spsummon effect init
    Sym.sp(c)
    --Duel.BreakEffect()
    Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.filter(c)
    return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and Sym.isyvwan(c)
end