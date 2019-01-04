--守护的星晶兽 雅典娜
function c47510001.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510001.psplimit)
    c:RegisterEffect(e1) 
    --pendulum set
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510001)
    e2:SetCondition(c47510001.pencon)
    e2:SetTarget(c47510001.pentg)
    e2:SetOperation(c47510001.penop)
    c:RegisterEffect(e2)
    --serch
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47510002)
    e3:SetTarget(c47510001.thtg2)
    e3:SetOperation(c47510001.thop2)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --sunmoneffect
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1,47510000)
    e5:SetCost(c47510001.cost)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetOperation(c47510001.ssop)
    c:RegisterEffect(e5)
    c47510001.ss_effect=e5
    --summon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47510001,0))
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_SUMMON_PROC)
    e6:SetRange(LOCATION_HAND)
    e6:SetCondition(c47510001.ntcon)
    c:RegisterEffect(e6)
    --act limit
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_CHAINING)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c47510001.chaincon)
    e7:SetOperation(c47510001.chainop)
    c:RegisterEffect(e7)
end
function c47510001.pefilter(c)
    return c:IsRace(RACE_FAIRY) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_FIRE)
end
function c47510001.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510001.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510001.cfilter(c)
    return c:IsSetCard(0x5de) or c:IsSetCard(0x5da) 
end
function c47510001.pencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47510001.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47510001.penfilter(c)
    return c:IsSetCard(0x5da) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and not c:IsCode(47510001)
end
function c47510001.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(c47510001.penfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetTargetCard(sc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0)
end
function c47510001.penop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c47510001.penfilter,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
    end
end
function c47510001.thfilter(c)
    return c:IsSetCard(0x5da) and c:IsAbleToHand() and not c:IsCode(47510001)
end
function c47510001.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510001.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47510001.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47510001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510001.ssop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e2:SetCondition(c47510001.rdcon)
    e2:SetOperation(c47510001.rdop)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c47510001.rdcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function c47510001.rdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(tp,ev/2)
end
function c47510001.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5)
        and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47510001.chaincon(e,tp,eg,ep,ev,re,r,rp)
    local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
    local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
    return ct1<ct2
end
function c47510001.chainop(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsSetCard(0x5da) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
        Duel.SetChainLimit(c47510001.chainlm)
    end
end
function c47510001.chainlm(e,rp,tp)
    return tp==rp
end