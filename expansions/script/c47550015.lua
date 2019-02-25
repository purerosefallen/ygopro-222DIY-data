--学院的守护公主 安
function c47550015.initial_effect(c)
    c:EnableCounterPermit(0x1)
    c:SetCounterLimit(0x1,3)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),2,3,c47550015.lcheck)
    c:EnableReviveLimit()
    --extra link
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetTarget(c47550015.mattg)
    e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
    e0:SetTargetRange(LOCATION_PZONE,0)
    e0:SetValue(c47550015.matval)
    c:RegisterEffect(e0) 
    --attackup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c47550015.attackup)
    c:RegisterEffect(e1) 
    --add counter
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(aux.chainreg)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c47550015.acop)
    c:RegisterEffect(e3) 
    --tg
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47550015,0))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c47550015.cost)
    e4:SetOperation(c47550015.operation)
    c:RegisterEffect(e4)
    --inm
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(10678778,0))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,47550015)
    e5:SetCost(c47550015.inmcost)
    e5:SetOperation(c47550015.inmop)
    c:RegisterEffect(e5)
end
function c47550015.lfilter(c)
    return c:IsCanAddCounter(0x1,1) and c:IsType(TYPE_PENDULUM)
end
function c47550015.lcheck(g,lc)
    return g:IsExists(c47550015.lfilter,1,nil)
end
function c47550015.matval(e,c,mg)
    return c:IsCode(47550015)
end
function c47550015.mattg(e,c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:GetOriginalRace()==RACE_SPELLCASTER
end
function c47550015.acop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
        e:GetHandler():AddCounter(0x1,1)
    end
end
function c47550015.attackup(e,c)
    return c:GetCounter(0x1)*800
end
function c47550015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x1,1,REASON_COST)
end
function c47550015.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c47550015.fop1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BECOME_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c47550015.fop2)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c47550015.efftg)
    e3:SetValue(aux.tgoval)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetValue(c47550015.atlimit)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp) 
end
function c47550015.atlimit(e,c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsCode(47550015)
end
function c47550015.efftg(e,c)
    return not c:IsCode(47550015)
end
function c47550015.fop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetHandler():IsCanRemoveCounter(tp,0x1,1,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(47550015,3)) then 
        Duel.NegateAttack() 
        e:GetHandler():RemoveCounter(tp,0x1,1,REASON_COST)
    end
end
function c47550015.fop2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if e:GetHandler():IsCanRemoveCounter(tp,0x1,1,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(47550015,3)) then
        Duel.NegateEffect(ev)  
        e:GetHandler():RemoveCounter(tp,0x1,1,REASON_COST)        
    end
end
function c47550015.inmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,3,REASON_COST) end
    Duel.RemoveCounter(tp,1,0,0x1,3,REASON_COST)
end
function c47550015.inmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetValue(c47550015.efilter)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
    c:RegisterEffect(e1)
end
function c47550015.efilter(e,re)
    return re:GetOwnerPlayer()~=e:GetOwnerPlayer()
end