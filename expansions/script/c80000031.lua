--超越者 机械降神
local m=80000031
local cm=_G["c"..m]
cm.is_named_with_yvwan=1
xpcall(function() require("expansions/script/c80000000") end,function() require("script/c80000000") end)
function cm.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Sym.isyvwan),2)  
    --Deus ex Machina
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCondition(cm.con)
    e1:SetTarget(cm.tg)
    e1:SetOperation(cm.op)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,2))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(cm.spcon)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
end
function cm.thfilter1(c)
    return Sym.isyvwan(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.thfilter2(c)
    return Sym.isyvwan(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFacedown()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
    return lg and eg:IsExists(cm.spfilter,1,nil,lg)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
    local ug=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_DECK,0,nil)
    local dg=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_DECK,0,nil)
    if ug:GetCount()>0 then
        Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,3))
        Duel.ConfirmCards(tp,ug)
    end
    if dg:GetCount()>0 then
        Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,4))
        Duel.ConfirmCards(tp,dg)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function cm.spfilter(c,g)
    return Sym.isartifact(c) and c:IsFaceup() and g:IsContains(c)
end
function cm.matfilter(c,e,tp)
    return Sym.isyvwan(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    --damage
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetCondition(cm.drcon)
    e1:SetOperation(cm.drop)
    Duel.RegisterEffect(e1,tp)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
    local num=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    return (num%2)==0 and Duel.GetTurnPlayer()==tp
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
    Duel.Draw(tp,4,REASON_EFFECT)
    local bg=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_HAND,0,nil)
    Duel.SendtoDeck(bg,tp,2,REASON_EFFECT)
end
function cm.tdfilter(c)
    return not Sym.isyvwan(c)
end