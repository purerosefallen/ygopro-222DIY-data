--奈落的星晶兽 哈迪斯
local m=47510081
local cm=_G["c"..m]
function c47510081.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,4,c47510081.lcheck)
    c:EnableReviveLimit() 
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c47510081.tgcon)
    e1:SetTarget(c47510081.tgtg)
    e1:SetOperation(c47510081.tgop)
    c:RegisterEffect(e1)
    --cannot act
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetCondition(c47510081.incon1)
    e2:SetValue(c47510081.aclimit)
    c:RegisterEffect(e2)
    --cannot remove
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_REMOVE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_GRAVE)
    e3:SetCondition(c47510081.incon1)
    c:RegisterEffect(e3)
    --tograve
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_START)
    e4:SetCondition(c47510081.incon2)
    e4:SetTarget(c47510081.destg)
    e4:SetOperation(c47510081.desop)
    c:RegisterEffect(e4)
    --immune
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c47510081.incon3)
    e5:SetValue(c47510081.efilter)
    c:RegisterEffect(e5)
    --disable spsummon
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_CANNOT_SUMMON)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetTargetRange(0,1)
    e6:SetCondition(c47510081.incon4)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    c:RegisterEffect(e7)
end
function c47510081.lcheck(g)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x5da) or g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end
function c47510081.aclimit(e,re,tp)
    return re:GetActivateLocation()==LOCATION_GRAVE
end
function c47510081.incon1(e,c,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroupCount()>=1
end
function c47510081.incon2(e,c,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroupCount()>=2
end
function c47510081.incon3(e,c,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroupCount()>=3
end
function c47510081.incon4(e,c,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroupCount()>=4
end
function c47510081.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47510081.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToGrave,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,lg,lg:GetCount(),0,0)
end
function c47510081.tgop(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
    Duel.SendtoGrave(lg,nil,REASON_EFFECT)
end
function c47510081.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end
function c47510081.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function c47510081.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end