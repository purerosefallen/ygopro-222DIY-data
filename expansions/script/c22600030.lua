--音语—变徵之流筝
function c22600030.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)

    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c22600030.spcon)
    c:RegisterEffect(e2)

    --tuner
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(c22600030.tnop)
    c:RegisterEffect(e3)

    --lv change
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetCategory(CATEGORY_REMOVE+CATEGORY_LVCHANGE)
    e4:SetCountLimit(1)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c22600030.tg)
    e4:SetOperation(c22600030.op)
    c:RegisterEffect(e4)
end

function c22600030.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)>=7
end

function c22600030.tnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetValue(TYPE_TUNER)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end

function c22600030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local lv=e:GetHandler():GetLevel()
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600030,0))
    e:SetLabel(Duel.AnnounceLevel(tp,1,6,lv))
end

function c22600030.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(e:GetLabel())
        c:RegisterEffect(e1)
    end
    local x=c:GetLevel()
    if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=x then
        local g=Duel.GetDecktopGroup(1-tp,x)
        Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
    end
end
