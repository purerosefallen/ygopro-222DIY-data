--黄金的女儿 茶会
local m=12007031
local cm=_G["c"..m]
--黄金的女儿 学习会
function cm.initial_effect(c)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.negcon)
    e2:SetTarget(cm.negtg)
    e2:SetOperation(cm.negop)
    c:RegisterEffect(e2)
    -- Equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    --Destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetTarget(cm.desreptg)
    e2:SetOperation(cm.desrepop)
    c:RegisterEffect(e2)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if not Duel.NegateActivation(ev) then return end
    if rc:IsRelateToEffect(re) and Duel.Destroy(eg:AddCard(e:GetHandler()),REASON_EFFECT)>1 and not rc:IsLocation(LOCATION_HAND+LOCATION_DECK)
        and not rc:IsHasEffect(EFFECT_NECRO_VALLEY) then
        if (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
            and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
            Duel.BreakEffect()
            Duel.SSet(tp,rc)
            Duel.ConfirmCards(1-tp,rc)
        end
    end
end
function cm.filter1(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0xfb2) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return  c:GetEquipGroup():IsExists(cm.filter1,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
end
function cm.repfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        local g=c:GetEquipGroup()
        return not c:IsReason(REASON_REPLACE) and g:IsExists(cm.repfilter,1,nil)
    end
    if Duel.SelectEffectYesNo(tp,c,96) then
        local g=c:GetEquipGroup()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=g:FilterSelect(tp,cm.repfilter,1,1,nil)
        Duel.SetTargetCard(sg)
        return true
    else return false end
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end