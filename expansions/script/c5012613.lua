--手办
function c5012613.initial_effect(c)
    --synchro summon
    c:EnableReviveLimit()
    aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsCode,5012604))
    --cannot trigger
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_TRIGGER)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e2:SetTarget(c5012613.tg)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e3:SetTarget(c5012613.distg2)
    c:RegisterEffect(e3)
    --disable effect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAIN_SOLVING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetOperation(c5012613.disop)
    c:RegisterEffect(e4)
    --immune
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(c5012613.efilter)
    c:RegisterEffect(e6)
    --cannot be battle target
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e7:SetCondition(c5012613.cntgcon)
    e7:SetValue(1)
    c:RegisterEffect(e7)
    --add code
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e8:SetCode(EFFECT_ADD_SETCODE)
    e8:SetValue(0x250)
    c:RegisterEffect(e8)
    local e18=e8:Clone()
    e8:SetValue(0x35a)
    c:RegisterEffect(e8)
    --material limit
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e9:SetValue(1)
    c:RegisterEffect(e9)
    local e10=e9:Clone()
    e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    c:RegisterEffect(e10)
    local e11=e9:Clone()
    e11:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e11)
    local e12=e9:Clone()
    e12:SetCode(EFFECT_UNRELEASABLE_SUM)
    c:RegisterEffect(e12)
    local e13=e9:Clone()
    e13:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e13)
    local e18=e9:Clone()
    e18:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e18)
    --to grave
    local e14=Effect.CreateEffect(c)
    e14:SetCategory(CATEGORY_TOGRAVE)
    e14:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e14:SetCode(EVENT_SPSUMMON_SUCCESS)
    e14:SetProperty(EFFECT_FLAG_DELAY)
    e14:SetCondition(c5012613.tgcon)
    e14:SetOperation(c5012613.tgop)
    c:RegisterEffect(e14)
    --lp
    local e15=Effect.CreateEffect(c)
    e15:SetType(EFFECT_TYPE_SINGLE)
    e15:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e15:SetRange(LOCATION_MZONE)
    e15:SetCode(EFFECT_SET_ATTACK)
    e15:SetCondition(c5012613.lpcon)
    e15:SetValue(0)
    c:RegisterEffect(e15)
    local e16=e15:Clone()
    e16:SetCode(EFFECT_SET_DEFENSE)
    c:RegisterEffect(e16)
    local e17=Effect.CreateEffect(c)
    e17:SetDescription(aux.Stringid(5012601,0))
    e17:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
    e17:SetType(EFFECT_TYPE_QUICK_O)
    e17:SetCode(EVENT_FREE_CHAIN)
    e17:SetHintTiming(0,0x1e0)
    e17:SetRange(LOCATION_MZONE)
    e17:SetCountLimit(1)
    e17:SetCondition(c5012613.lifecon)
    e17:SetTarget(c5012613.htg)
    e17:SetOperation(c5012613.hop)
    c:RegisterEffect(e17)
end
function c5012613.tg(e,c)
    return c:IsFacedown()
end
function c5012613.distg2(e,c)
    return c:IsType(TYPE_SPELL)
end
function c5012613.disop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_SPELL) then
        Duel.NegateEffect(ev)
    end
end
function c5012613.efilter(e,te)
    return te:GetHandler()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER)
end
function c5012613.ifilter(c)
    return  c:IsCode(5012604) or c:IsCode(5012631)
end
function c5012613.cntgcon(e)
    return Duel.IsExistingMatchingCard(c5012613.ifilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c5012613.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c5012613.tgfilter(c)
    return  not (c:IsSetCard(0x250) or c:IsSetCard(0x35a))  or c:IsFacedown()
end
function c5012613.tgop(e,tp,eg,ep,ev,re,r,rp)
        local tc1=Duel.GetMatchingGroup(c5012613.tgfilter,tp,LOCATION_ONFIELD,0,nil)
        local tc2=Duel.GetMatchingGroup(c5012613.tgfilter,tp,0,LOCATION_ONFIELD,nil)
        if tc1:GetCount()>0 or tc2:GetCount()>0  then
        tc1:Merge(tc2)
        Duel.SendtoGrave(tc1,REASON_RULE)
end
end
function c5012613.lpcon(e,c)
    return Duel.GetLP(e:GetHandlerPlayer())>50
end
function c5012613.lifecon(e,c)
    return Duel.GetLP(e:GetHandlerPlayer())<=50
end
function c5012613.htg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c5012613.hfilter(c)
    return  not (c:IsSetCard(0x250) or c:IsSetCard(0x35a) )
end
function c5012613.hop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c5012613.hfilter,1-tp,LOCATION_HAND,0,nil)
    if g:GetCount()>0 then
    local re=Duel.SendtoGrave(g,REASON_RULE)
    if re>0 then
    Duel.Recover(tp,re*500,REASON_EFFECT)   
    Duel.Damage(1-tp,re*500,REASON_EFFECT)  
     end
    else
        local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
        Duel.ConfirmCards(tp,hg)
        Duel.ShuffleHand(1-tp)
    end
end
