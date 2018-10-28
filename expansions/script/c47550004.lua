--超古代兵器 卡塔碧拉&维拉
local m=47550004
local cm=_G["c"..m]
function c47550004.initial_effect(c)
    --summon with 1 tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47550004,1))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c47550004.otcon)
    e1:SetOperation(c47550004.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47550004,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47550004)
    e2:SetTarget(c47550004.sptg)
    e2:SetOperation(c47550004.spop)
    c:RegisterEffect(e2)   
    --summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47550004,0))
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SUMMON_PROC)
    e3:SetRange(LOCATION_HAND)
    e3:SetCondition(c47550004.ntcon)
    c:RegisterEffect(e3) 
    --immune
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c47550004.defcon)
    e4:SetValue(c47550004.efilter)
    c:RegisterEffect(e4)
    --actlimit
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EFFECT_CANNOT_ACTIVATE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,1)
    e5:SetValue(c47550004.aclimit)
    e5:SetCondition(c47550004.actcon)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(e:GetHandler())
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetCondition(c47550004.atkcon)
    e6:SetOperation(c47550004.disop)
    c:RegisterEffect(e6,tp)
    local e7=e2:Clone()
    e7:SetCode(EVENT_BE_BATTLE_TARGET)
    c:RegisterEffect(e7)
end
function c47550004.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47550004.atkcon(e)
    return e:GetHandler():IsAttackPos()
end
function c47550004.defcon(e)
    return e:GetHandler():IsDefensePos()
end
function c47550004.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c47550004.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() and e:GetHandler():IsAttackPos()
end
function c47550004.otfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47550004.otcon(e,c,minc)
    if c==nil then return true end
    local mg=Duel.GetMatchingGroup(c47550004.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c47550004.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c47550004.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c47550004.spfilter(c,e,tp)
    return c:IsSetCard(0x5d5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47550004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and chkc:IsFaceup() end
    if chk==0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<-1 then return false end
        local loc=LOCATION_ONFIELD
        if ft==0 then loc=LOCATION_MZONE end
        e:SetLabel(loc)
        return Duel.IsExistingTarget(Card.IsFaceup,tp,loc,0,1,e:GetHandler())
            and Duel.IsExistingMatchingCard(c47550004.spfilter,tp,LOCATION_DECK,0,1,e:GetHandler(),e,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,e:GetLabel(),0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47550004.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c47550004.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function c47550004.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5)
        and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47550004.actcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
    return tc and tc:IsControler(tp)
end
function c47550004.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    if not tc then return end
    if tc:IsControler(tp) then tc=Duel.GetAttacker() end
    c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetCondition(c47550004.discon2)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetCondition(c47550004.discon2)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
    tc:RegisterEffect(e2)
end
function c47550004.discon2(e)
    return e:GetOwner():IsRelateToCard(e:GetHandler())
end