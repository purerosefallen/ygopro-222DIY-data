--反骨的强者 勇
function c10126005.initial_effect(c)
	--summon with 2 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126005,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c10126005.otcon)
	e1:SetOperation(c10126005.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126005,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c10126005.spcon)
	e3:SetTarget(c10126005.sptg)
	e3:SetOperation(c10126005.spop)
	c:RegisterEffect(e3) 
	--Equip
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetDescription(aux.Stringid(10126005,2))
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_EQUIP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10126005.eqcon)
	e4:SetTarget(c10126005.eqtg)
	e4:SetOperation(c10126005.eqop)
	c:RegisterEffect(e4)
end
function c10126005.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10126005.cfilter2,1,nil,tp)
end
function c10126005.cfilter2(c,tp)
	return c:GetEquipTarget():IsControler(tp)
end
function c10126005.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,1-tp,LOCATION_EXTRA)
end
function c10126005.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c,g=e:GetHandler(),Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()<=0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=g:RandomSelect(tp,1):GetFirst()
	if not Duel.Equip(1-tp,tc,c,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c10126005.eqlimit)
	tc:RegisterEffect(e1)
	local cid=c:CopyEffect(tc:GetOriginalCodeRule(),RESET_EVENT+0x1fe0000)
end
function c10126005.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10126005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD+LOCATION_HAND)
end
function c10126005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10126005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c10126005.otfilter(c,tp)
	if c:IsHasEffect(EFFECT_CANNOT_RELEASE) or not Duel.IsPlayerCanRelease(tp,c) then return false end
	--if not c:IsReleasable() then return false end
	if c:IsLocation(LOCATION_SZONE) then return c:GetEquipTarget() and c:GetEquipTarget():IsControler(tp)
	else return c:IsSetCard(0x1335)
	end
end
function c10126005.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>4 and minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10126005.otfilter,tp,LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE,2,c,tp)
end
function c10126005.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c10126005.otfilter,tp,LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE,2,2,c,tp)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end