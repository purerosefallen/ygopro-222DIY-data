--理想的神王 罗密欧
function c47551100.initial_effect(c)
    c:EnableCounterPermit(0x45d0)
    c:SetCounterLimit(0x45d0,1)
    --pendulum summon
    aux.EnablePendulumAttribute(c)   
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47551100,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47551100)
    e1:SetCondition(c47551100.hspcon)
    e1:SetOperation(c47551100.hspop)
    c:RegisterEffect(e1)  
    --summon with 1 tribute
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47551100,2))
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SUMMON_PROC)
    e3:SetCondition(c47551100.otcon)
    e3:SetOperation(c47551100.otop)
    e3:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e3)
    --summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47551100,3))
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_SUMMON_PROC)
    e4:SetRange(LOCATION_HAND)
    e4:SetCondition(c47551100.ntcon)
    c:RegisterEffect(e4) 
    --ereinokakou
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47551100,4))
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetOperation(c47551100.opd1)
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
    e7:SetValue(c47551100.attackup)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47551100,5))
    e8:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EVENT_FREE_CHAIN)
    e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e8:SetCost(c47551100.discost)
    e8:SetTarget(c47551100.distg)
    e8:SetOperation(c47551100.disop)
    c:RegisterEffect(e8)
end
function c47551100.opd1(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x45d0,1)
    end
end
function c47551100.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler()) and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47551100.tefilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x5d0)
end
function c47551100.hspop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47551100,0))
    local g=Duel.SelectMatchingCard(tp,c47551100.tefilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c47551100.otfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47551100.otcon(e,c,minc)
    if c==nil then return true end
    local mg=Duel.GetMatchingGroup(c47551100.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c47551100.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c47551100.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c47551100.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5)
        and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47551100.attackup(e,c)
    return c:GetCounter(0x45d0)*1000
end
function c47551100.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x45d0,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x45d0,1,REASON_COST)
end
function c47551100.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c47551100.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if Duel.Damage(1-tp,1500,REASON_EFFECT) and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e3)
        end
    end
end