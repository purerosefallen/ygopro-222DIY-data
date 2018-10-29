--恩布拉斯的契约者 贝阿朵利克斯
local m=47550002
local cm=_G["c"..m]
function c47550002.initial_effect(c)
    --material
    c:EnableReviveLimit() 
    aux.AddXyzProcedure(c,nil,8,2)
    aux.EnablePendulumAttribute(c,false)  
    --material
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47550002)
    e1:SetTarget(c47550002.psptg)
    e1:SetOperation(c47550002.pspop)
    c:RegisterEffect(e1)  
    --atk up
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47550002,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(2)
    e2:SetOperation(c47550002.atkop)
    c:RegisterEffect(e2)  
    --double atk
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    e3:SetCondition(c47550002.dacon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetCondition(c47550002.tacon)
    e4:SetValue(2)
    c:RegisterEffect(e4)
    --to defense
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47550002,2))
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c47550002.poscon)
    e5:SetOperation(c47550002.posop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47550002,3))
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(c47550002.tacon)
    e6:SetOperation(c47550002.damop)
    c:RegisterEffect(e6)
    --destroy&damage
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e7:SetDescription(aux.Stringid(47550002,1))
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetCountLimit(1)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c47550002.cost)
    e7:SetTarget(c47550002.tgtg)
    e7:SetOperation(c47550002.tgop)
    c:RegisterEffect(e7)
    --battle indes
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e8:SetCountLimit(1)
    e8:SetValue(c47550002.valcon)
    c:RegisterEffect(e8)  
end
c47550002.pendulum_level=8
function c47550002.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
function c47550002.pspfilter(c,tp)
    return not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c47550002.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMZoneCount(tp)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():GetOriginalType(TYPE_XYZ)
        and Duel.IsExistingTarget(c47550002.pspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c47550002.pspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47550002.pspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
    local og=tc:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
function c47550002.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
        c:RegisterFlagEffect(47550002,RESET_EVENT+RESETS_STANDARD,0,1)
    end
end
function c47550002.dacon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47550002)==1
end
function c47550002.tacon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47550002)==2
end
function c47550002.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetAttackedCount()>0 and e:GetHandler():GetFlagEffect(47550002)==2
end
function c47550002.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
function c47550002.damop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetAttack()
    Duel.Damage(tp,atk,REASON_EFFECT)
end
function c47550002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47550002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c47550002.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    local atk=tc:GetTextAttack()
    if atk<0 then atk=0 end
    if Duel.SendtoGrave(tc,REASON_EFFECT) then
        Duel.Damage(tp,atk,REASON_EFFECT)
    end
end