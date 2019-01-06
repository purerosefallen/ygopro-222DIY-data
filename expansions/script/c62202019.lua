--降临于新的旅途
local m=62202019
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
    c:RegisterEffect(e1)
    --change draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetCountLimit(1,622020191+EFFECT_COUNT_CODE_DUEL)
    e2:SetCondition(cm.con1)
    e2:SetOperation(cm.op1)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCountLimit(1,622020191+EFFECT_COUNT_CODE_DUEL)
    e3:SetCondition(cm.spcon)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    c:RegisterEffect(e3)  
end
function cm.con1filter(c,tp)
    return c:GetBaseAttack()==0 and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.con1filter,1,nil,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e2_1=Effect.CreateEffect(c)
    e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2_1:SetType(EFFECT_TYPE_FIELD)
    e2_1:SetCode(EFFECT_DRAW_COUNT)
    e2_1:SetTargetRange(1,0)
    e2_1:SetValue(2)
    e2_1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
    Duel.RegisterEffect(e2_1,tp)
end
--
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    if c==nil then return true end
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_FZONE) and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.spfilter(c,e,tp)
    return c:GetBaseAttack()==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
                e1:SetValue(cm.limit)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
                tc:RegisterEffect(e2)
                local e3=e1:Clone()
                e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
                tc:RegisterEffect(e3)
                local e4=e1:Clone()
                e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
                tc:RegisterEffect(e4)
    end
end
function cm.limit(e,c)
    if not c then return false end
    return c:GetBaseAttack()~=0
end