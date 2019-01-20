--圣王女 朱丽叶
function c47551102.initial_effect(c)
    c:EnableCounterPermit(0x45d0)
    c:SetCounterLimit(0x45d0,1)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum change
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_IMMUNE_EFFECT)
    e0:SetRange(LOCATION_PZONE)
    e0:SetTargetRange(LOCATION_PZONE,0)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e0:SetValue(c47551102.efilter)
    e0:SetTarget(c47551102.eftg)
    c:RegisterEffect(e0)   
    --summon with 1 tribute
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47551102,3))
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SUMMON_PROC)
    e3:SetCondition(c47551102.otcon)
    e3:SetOperation(c47551102.otop)
    e3:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e3)
    --summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47551102,4))
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_SUMMON_PROC)
    e4:SetRange(LOCATION_HAND)
    e4:SetCondition(c47551102.ntcon)
    c:RegisterEffect(e4) 
    --ereinokakou
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47551102,5))
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetOperation(c47551102.opd1)
    c:RegisterEffect(e6)
    local e5=e6:Clone()
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --atk up
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_UPDATE_ATTACK)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(c47551102.attackup)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47551102,6))
    e8:SetCategory(CATEGORY_RECOVER)
    e8:SetType(EFFECT_TYPE_QUICK_O)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EVENT_FREE_CHAIN)
    e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e8:SetCost(c47551102.reccost)
    e8:SetTarget(c47551102.rectg)
    e8:SetOperation(c47551102.recop)
    c:RegisterEffect(e8)
end
function c47551102.efilter(e,te)
    if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
end
function c47551102.eftg(e,c)
    return c~=e:GetHandler()
end
function c47551102.opd1(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x45d0,1)
    end
end
function c47551102.otfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47551102.otcon(e,c,minc)
    if c==nil then return true end
    local mg=Duel.GetMatchingGroup(c47551102.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c47551102.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c47551102.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c47551102.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5)
        and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47551102.attackup(e,c)
    return c:GetCounter(0x45d0)*1000
end
function c47551102.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x45d0,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x45d0,1,REASON_COST)
end
function c47551102.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c47551102.recop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if Duel.Recover(tp,1500,REASON_EFFECT) and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(c47551102.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c47551102.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end