--传灵 百目
local m=22600108
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_SPIRIT),1,1)
    c:EnableReviveLimit()
    c:SetSPSummonOnce(m)
    --damage
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(cm.dcon)
    e1:SetCost(cm.dcost)
    e1:SetOperation(cm.dop)
    c:RegisterEffect(e1)
    --flip
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.fcon)
    e2:SetTarget(cm.ftg)
    e2:SetOperation(cm.fop)
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
function cm.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,800,REASON_EFFECT)
end
function cm.fcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.ffilter(c,lg)
    return c:IsControlerCanBeChanged() and lg and lg:IsContains(c)
end
function cm.ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local lg=e:GetHandler():GetLinkedGroup()
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.ffilter(chkc,lg) end
    if chk==0 then return Duel.IsExistingTarget(cm.ffilter,tp,0,LOCATION_MZONE,1,nil,lg) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,cm.ffilter,tp,0,LOCATION_MZONE,1,1,nil,lg)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.fop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp)
        tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetOperation(cm.desop)
        e1:SetLabelObject(tc)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoHand(tc,nil,REASON_EFFECT)
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