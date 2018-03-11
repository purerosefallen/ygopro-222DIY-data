--最幸的星承 小河坂梦
local m=10905011
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(cm.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(cm.spcon)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)   
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCondition(cm.sumcon)
    e3:SetOperation(cm.sumsuc)
    c:RegisterEffect(e3)   
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(54631665,0))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(cm.thtg)
    e4:SetOperation(cm.thop)
    c:RegisterEffect(e4)
end
function cm.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cm.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cm.spfilter1(c,tp,fc)
    return c:IsFusionCode(10905006)  and c:IsCanBeFusionMaterial(fc)
        and Duel.CheckReleaseGroup(tp,cm.spfilter2,1,c,fc)
end
function cm.spfilter2(c,fc)
    return  c:IsFusionCode(10905008)   and c:IsCanBeFusionMaterial(fc)
end
function cm.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetMZoneCount(tp)>-2
        and Duel.CheckReleaseGroup(tp,cm.spfilter1,1,nil,tp,c)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectReleaseGroup(tp,cm.spfilter1,1,1,nil,tp,c)
    local g2=Duel.SelectReleaseGroup(tp,cm.spfilter2,1,1,g1:GetFirst(),c)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
    local p=10905000
    return Duel.GetFlagEffect(tp,p+1)~=0 and
    Duel.GetFlagEffect(tp,p+2)~=0 and Duel.GetFlagEffect(tp,p+3)~=0 and
    Duel.GetFlagEffect(tp,p+4)~=0 and Duel.GetFlagEffect(tp,p+5)~=0 and 
    Duel.GetFlagEffect(tp,p+6)~=0 and Duel.GetFlagEffect(tp,p+7)~=0
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(cm.actlimit)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e:GetHandler():RegisterEffect(e2)
end
function cm.actlimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.thfilter(c)
    return c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end