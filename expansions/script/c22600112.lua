--传灵 藻女
local m=22600112
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,cm.matfilter,1,1)
    c:EnableReviveLimit()
	c:SetSPSummonOnce(m)
    --control
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL+CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(cm.ctg)
    e1:SetOperation(cm.cop)
    c:RegisterEffect(e1)
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetValue(cm.dlimit)
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
function cm.matfilter(c)
    return c:IsLinkSetCard(0x261) and not c:IsType(TYPE_LINK)
end
function cm.cfilter(c)
    return c:IsType(TYPE_SPIRIT) and c:IsSummonable(true,nil)
end
function cm.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_MZONE) end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function cm.cop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    Duel.GetControl(c,1-tp)
    if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) then
        Duel.Hint(HINT_SELECTMSG,CATEGORY_SUMMON,HINTMSG_SUMMON)
        local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
        Duel.Summon(tp,g:GetFirst(),true,nil)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetTargetRange(LOCATION_MZONE,0)
        e1:SetTarget(cm.atktg)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function cm.atktg(e,c)
    return not c:IsType(TYPE_SPIRIT)
end
function cm.aclimit(e)
    return not e:GetHandler()
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