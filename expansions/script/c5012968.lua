--绚烂的纺织者 可露瓦
function c5012968.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --add counter
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(EVENT_CHAINING)
    e0:SetRange(LOCATION_MZONE)
    e0:SetOperation(aux.chainreg)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_CHAIN_SOLVED)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c5012968.acop)
    c:RegisterEffect(e1)
    --add counter
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c5012968.ctop)
    c:RegisterEffect(e2)
    --atkdown
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c5012968.cost)
    e3:SetOperation(c5012968.operation)
    c:RegisterEffect(e3)
end
function c5012968.acop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasType(EFFECT_TYPE_ACTIONS) and e:GetHandler():GetFlagEffect(1)>0 
        and e:GetHandler():GetCounter(0x1024)<10 then
        e:GetHandler():AddCounter(0x1024,2)
    end
end
function c5012968.ctop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():GetCounter(0x1024)<10 then e:GetHandler():AddCounter(0x1024,2) end
end
function c5012968.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetCounter(0x1024)>2 end
    local ct=e:GetHandler():GetCounter(0x1024)
    e:SetLabel(ct)
    e:GetHandler():RemoveCounter(tp,0x1024,ct,REASON_COST)
end
function c5012968.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    if g:GetCount()>0 then
        local sc=g:GetFirst()
        local ct=e:GetLabel()
        if ct>2 and ct<7 then
            while sc do 
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(500)
                e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
                sc:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_UPDATE_DEFENSE)
                sc:RegisterEffect(e2)
                sc=g:GetNext()
                end
        elseif ct>6 and ct<10 then
            while sc do
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(1000)
                e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
                sc:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_UPDATE_DEFENSE)
                sc:RegisterEffect(e2)
                sc=g:GetNext()
            end
        elseif ct>9 then
            while sc do 
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(2000)
                e1:SetReset(RESET_EVENT+0x1ff0000)
                sc:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_UPDATE_DEFENSE)
                sc:RegisterEffect(e2)
                sc=g:GetNext()
            end
        end
    end
end