--传灵 乙姬
local m=22600110
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_SPIRIT),1,1)
    c:EnableReviveLimit()
    c:SetSPSummonOnce(m)
     --draw
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(cm.dcon)
    e1:SetTarget(cm.dtg)
    e1:SetOperation(cm.dop)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(cm.tg)
    e2:SetOperation(cm.op)
    c:RegisterEffect(e2)
    --return
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCondition(cm.retcon)
    e3:SetOperation(cm.retreg)
    c:RegisterEffect(e3)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetValue(cm.linklimit)
    c:RegisterEffect(e4)
end
function cm.linklimit(e,c)
    if not c then return false end
    return not c:IsSetCard(0x261)
end
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,1-tp,LOCATION_DECK)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
    local d1=Duel.Draw(tp,1,REASON_EFFECT)
    local tc1=Duel.GetOperatedGroup():GetFirst()
    Duel.ConfirmCards(1-tp,tc1)
    if tc1:IsType(TYPE_MONSTER) then
        Duel.Damage(tp,tc1:GetLevel()*200,REASON_EFFECT)
    end
    Duel.ShuffleHand(tp)
    local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
    local tc2=Duel.GetOperatedGroup():GetFirst()
    Duel.ConfirmCards(tp,tc2)
    if tc2:IsType(TYPE_MONSTER) then
        Duel.Damage(1-tp,tc2:GetLevel()*200,REASON_EFFECT)
    end
    Duel.ShuffleHand(1-tp)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if eg:IsContains(tc) then
        return true
    else
        if not tc:IsLocation(LOCATION_HAND) then e:Reset() end
        return false
    end
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,700,REASON_EFFECT)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,e:GetHandler(),0x261) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
    local ag=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0x261)
    if ag:GetCount()>0 then
        Duel.SendtoHand(ag,1-tp,REASON_EFFECT)
        Duel.ConfirmCards(tp,ag)
        Duel.ShuffleHand(1-tp)
        Duel.ShuffleHand(tp)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_TO_GRAVE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetLabelObject(ag:GetFirst())
            e1:SetCondition(cm.damcon)
            e1:SetOperation(cm.damop)
            e1:SetReset(RESET_TODECK+RESET_REMOVE)
            Duel.RegisterEffect(e1,tp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
        if g:GetCount()>0 then
            Duel.BreakEffect()
            local sg=g:RandomSelect(1-tp,1)
            Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
        end
    end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.retreg(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetDescription(1104)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
    e1:SetCondition(aux.SpiritReturnCondition)
    e1:SetTarget(cm.rettg)
    e1:SetOperation(cm.retop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    c:RegisterEffect(e2)
end
function cm.retfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x261) and c:IsAbleToHand()
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
            return true
        else
            return Duel.GetMatchingGroupCount(cm.retfilter,tp,LOCATION_GRAVE,0,nil)>0
        end
    end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0
        and Duel.GetMatchingGroupCount(cm.retfilter,tp,LOCATION_GRAVE,0,nil)>0 then
        local g=Duel.GetMatchingGroup(cm.retfilter,tp,LOCATION_GRAVE,0,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local tg=Duel.SelectMatchingCard(tp,cm.retfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
    end
end