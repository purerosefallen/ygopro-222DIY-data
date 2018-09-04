--天光的星晶兽 宙斯
local m=47510078
local cm=_G["c"..m]
function c47510078.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,4,c47510078.lcheck)
    c:EnableReviveLimit()  
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,47510078)
    e1:SetCondition(c47510078.discon)
    e1:SetTarget(c47510078.distg)
    e1:SetOperation(c47510078.disop)
    c:RegisterEffect(e1) 
    --update atk,def
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c47510078.incon1)
    e2:SetValue(c47510078.val)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --immune
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c47510078.incon2)
    e4:SetValue(c47510078.efilter)
    c:RegisterEffect(e4)
    --double atk
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_EXTRA_ATTACK)
    e5:SetValue(2)
    e5:SetCondition(c47510078.incon3)
    c:RegisterEffect(e5)
    --actlimit
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetCode(EFFECT_CANNOT_ACTIVATE)
    e6:SetTargetRange(0,1)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c47510078.incon4)
    e6:SetValue(c47510078.aclimit)
    c:RegisterEffect(e6)
end
function c47510078.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c47510078.lcheck(g)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x5da) or g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
end
function c47510078.incon1(e,c,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroupCount()>=1
end
function c47510078.incon2(e,c,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroupCount()>=2
end
function c47510078.incon3(e,c,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroupCount()>=3
end
function c47510078.incon4(e,c,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroupCount()>=4
end
function c47510078.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47510078.discon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c47510078.disfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c47510078.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510078.disfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c47510078.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c47510078.disfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
        if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
            Duel.Destroy(eg,REASON_EFFECT)
        end
    end
end
function c47510078.val(e,c)
    local v=Duel.GetLP(c:GetControler())-Duel.GetLP(1-c:GetControler())
    if v>0 then return v else return 0 end
end