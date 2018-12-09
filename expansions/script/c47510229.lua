--漆黑的解放者 阿萨谢尔
local m=47510229
local cm=_G["c"..m]
function c47510229.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --summon with 1 tribute
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c47510229.otcon)
    e1:SetOperation(c47510229.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e2)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetRange(LOCATION_PZONE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,47510229)
    e2:SetCondition(c47510229.thcon)
    e2:SetOperation(c47510229.thop)
    c:RegisterEffect(e2)    
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetValue(c47510229.efilter2)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510229,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c47510229.spcon)
    e4:SetCost(c47510229.spcost)
    e4:SetOperation(c47510229.spop)
    c:RegisterEffect(e4)
end
function c47510229.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsType(TYPE_LINK)
end
function c47510229.otfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK)
end
function c47510229.otcon(e,c,minc)
    if c==nil then return true end
    local mg=Duel.GetMatchingGroup(c47510229.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c47510229.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c47510229.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c47510229.thcon(e,tp,eg,ep,ev,re,r,rp)
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 or not tc1:IsSetCard(0x5de) or not tc2:IsSetCard(0x5de) then return false end
    local scl1=tc1:GetLeftScale()
    local scl2=tc2:GetRightScale()
    if scl1>scl2 then scl1,scl2=scl2,scl1 end
    return scl1==1 and scl2==13
end
function c47510229.thfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c47510229.thop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetMatchingGroupCount(c47510229.thfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
    local tg=Duel.GetMatchingGroup(c47510229.thfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
    local g=nil
    if tg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g=tg:Select(tp,ft,ft,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510229.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c47510229.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end
function c47510229.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) or e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c47510229.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c47510229.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510229,2))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetValue(c47510229.pendvalue)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c47510229.pendvalue(e,c)
    return c:IsSetCard(0x5da) or c:IsSetCard(0x5de)
end