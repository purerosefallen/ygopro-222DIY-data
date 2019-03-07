--璀璨的星辉
function c66915001.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
    e2:SetValue(LINK_MARKER_TOP_RIGHT+LINK_MARKER_TOP_LEFT)
    c:RegisterEffect(e2) 
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e3)  
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c66915001.spcon)
    e1:SetTarget(c66915001.target)
    e1:SetOperation(c66915001.spop)
    c:RegisterEffect(e1)
    --move
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_IGNITION)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCountLimit(1)
    e11:SetCondition(c66915001.seqcon)
    e11:SetOperation(c66915001.seqop)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c66915001.eftg)
    e5:SetLabelObject(e11)
    c:RegisterEffect(e5)
    --spsummon limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c66915001.sumlimit)
    c:RegisterEffect(e2)
end
function c66915001.filter(c,e,tp)
    return  c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsSetCard(0x1374)
end
function c66915001.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCountFromEx(tp)>0 and
        Duel.IsExistingMatchingCard(c66915001.filters,tp,LOCATION_SZONE,0,1,nil)
end
function c66915001.filters(c,e,tp)
    return c:IsSetCard(0x374) and c:IsFaceup() 
end
function c66915001.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c66915001.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c66915001.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c66915001.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end
function c66915001.seqcon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
    if seq>4 then return false end
    return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
        or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c66915001.seqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
    local seq=c:GetSequence()
    if seq>4 then return end
    if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
        or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
        local flag=0
        if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
        if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
        flag=bit.bxor(flag,0xff)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
        local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
        local nseq=0
        if s==1 then nseq=0
        elseif s==2 then nseq=1
        elseif s==4 then nseq=2
        elseif s==8 then nseq=3
        else nseq=4 end
        Duel.MoveSequence(c,nseq)
    end
end
function c66915001.eftg(e,c)
    local lg=e:GetHandler():GetLinkedGroup()
    return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x1374) and lg:IsContains(c)
end
function c66915001.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1374)
end