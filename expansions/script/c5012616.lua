--一个好人
function c5012616.initial_effect(c)
    c:SetSPSummonOnce(5012616)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c5012616.mfilter,c5012616.xyzcheck,2,2)
    --atk
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetCondition(c5012616.atkcon)
    e3:SetValue(c5012616.atkval)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENCE)
    c:RegisterEffect(e4)
    --to deck
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(5012616,1))
    e5:SetCategory(CATEGORY_TODECK)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetHintTiming(0,0x1e0)
    e5:SetCost(c5012616.tdcost)
    e5:SetTarget(c5012616.tdtg)
    e5:SetOperation(c5012616.tdop)
    c:RegisterEffect(e5)
    --damage
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(5012616,0))
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCost(c5012616.cost)
    e6:SetOperation(c5012616.op)
    c:RegisterEffect(e6)
    --
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetCode(EFFECT_UPDATE_ATTACK)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(-65536)
    c:RegisterEffect(e7)
    local e8=e7:Clone()
    e8:SetCode(EFFECT_UPDATE_DEFENCE)
    c:RegisterEffect(e8)
    --
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e9:SetTargetRange(1,0)
    e9:SetTarget(c5012616.sumlimit)
    c:RegisterEffect(e9)
end
function c5012616.mfilter(c,xyzc)
    return c:IsSetCard(0x250) and c:IsFaceup() and c:IsLevelAbove(9) and not c:IsType(TYPE_TOKEN)
end
function c5012616.xyzcheck(g)
    return g:FilterCount(Card.IsLevelAbove,nil,9)==g:GetCount()
end
function c5012616.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0x250)
end
function c5012616.ovfilter(c,g)
    return c:IsSetCard(0x250)  and c:IsFaceup() and c:IsLevelAbove(9) and c:IsCanBeXyzMaterial(g) and not c:IsType(TYPE_TOKEN)
end
function c5012616.spcon(e,c)
    if  Duel.IsExistingMatchingCard(c5012616.ovfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil,e:GetHandler()) then return true
    else return false end
end
function c5012616.spop(e,tp,eg,ep,ev,re,r,rp,c) 
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c5012616.ovfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,2,nil,e:GetHandler())
    if g:GetCount()==2  then
    Duel.Overlay(c,g)
end
end
function c5012616.atkcon(e,c)
    return  e:GetHandler():GetOverlayCount()==0
end
function c5012616.atkval(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE)*1024
end
function c5012616.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
    local tc=c:GetOverlayCount()
    e:SetLabel(tc)
    e:GetHandler():RemoveOverlayCard(tp,tc,tc,REASON_COST)
end
function c5012616.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c5012616.tdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,nil)
    if g then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
function c5012616.filter(c)
    return  c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN) 
end
function c5012616.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c5012616.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and e:GetHandler():IsType(TYPE_XYZ) end
    local g=Duel.SelectMatchingCard(tp,c5012616.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
    local tc=g:GetFirst()
    if tc and not tc:IsImmuneToEffect(e) then
        local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(e:GetHandler(),Group.FromCards(tc))
    end
end
function c5012616.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_CHAINING)
    e1:SetOperation(c5012616.regop)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVED)
    e2:SetCondition(c5012616.damcon)
    e2:SetOperation(c5012616.damop)
    e2:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(0,1)
    e3:SetValue(c5012616.actlimit)
    e3:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e3,tp)
end
function c5012616.regop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(5012616,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function c5012616.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep~=tp and c:GetFlagEffect(5012616)~=0
end
function c5012616.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,5012616)
    Duel.Damage(1-tp,800,REASON_EFFECT)
end
function c5012616.actlimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER)
end