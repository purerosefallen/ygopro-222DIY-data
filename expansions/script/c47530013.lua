--葵曼沙
local m=47530013
local cm=_G["c"..m]
function c47530013.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),4,99,c47530013.lcheck)
    c:EnableReviveLimit()    
    --tograve
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530013,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c47530013.tgcon)
    e1:SetOperation(c47530013.tgop)
    c:RegisterEffect(e1)  
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47530013,1))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetTarget(c47530013.eqtg)
    e2:SetOperation(c47530013.eqop)
    c:RegisterEffect(e2)  
    --effect gian
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47530013,2))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_ADJUST)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c47530013.efop)
    c:RegisterEffect(e3)
end
function c47530013.lcheck(g,lc)
    return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c47530013.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47530013.tgfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsDisabled()
end
function c47530013.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47530013.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    local tc=g:GetFirst()
    while tc do
        Duel.SendtoGrave(tc,REASON_RULE)
        local code=tc:GetOriginalCode()
        if c:IsFaceup() and c:GetFlagEffect(code)==0 then
        c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
        c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
        end 
    tc=g:GetNext()
    end
end
function c47530013.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc and tc:IsFaceup() and tc:GetAttack()<=c:GetAttack() end
end
function c47530013.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() and tc:GetAttack()<=c:GetAttack() then
        if tc:IsFaceup() and tc:IsType(TYPE_MONSTER)then
        if c:IsFaceup() then
            if not Duel.Equip(tp,tc,c,false) then return end
            --Add Equip limit
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(c47530013.eqlimit)
            tc:RegisterEffect(e1)
        else Duel.SendtoGrave(tc,REASON_RULE) end
        end
    end
end
function c47530013.eqlimit(e,c)
    return e:GetOwner()==c
end
function c47530013.rtgfilter(c)
    return c:GetOriginalType(TYPE_MONSTER) and c:GetOriginalType(TYPE_EFFECT)
end
function c47530013.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()  
    local eq=c:GetEquipGroup(c47530013.rtgfilter,1,nil,tp)
    local wg=eq:Filter(c47530013.rtgfilter,nil,tp)
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        if c:IsFaceup() and c:GetFlagEffect(code)==0 then
        c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
        c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
        end 
        wbc=wg:GetNext()
    end  
end