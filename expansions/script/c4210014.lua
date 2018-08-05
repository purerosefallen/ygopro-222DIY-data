--猫耳天堂-Coconut
function c4210014.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c4210014.splimit)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210014,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(SUMMON_TYPE_SPECIAL)
	e2:SetCondition(c4210014.spcon)
	e2:SetOperation(c4210014.spop)
	c:RegisterEffect(e2)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210014,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)	
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c4210014.ottg)
	e3:SetOperation(c4210014.otop)
	c:RegisterEffect(e3)
	--spsummon count limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(function(e,c)return e:GetHandler():GetFlagEffect(4210014)~=0 end)
	e4:SetTargetRange(1,1)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--extra summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(function(e,c)return e:GetHandler():GetFlagEffect(4210014)~=0 end)
	e5:SetTargetRange(1,1)
	e5:SetValue(1)
	c:RegisterEffect(e5)	
end
function c4210014.spcfilter(c,e,tp)
	return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:GetSummonPlayer()==tp
end
function c4210014.ottg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c4210014.spcfilter,1,nil,e,tp) end
	local g=eg:Filter(c4210014.spcfilter,nil,e,tp)
	Duel.SetTargetCard(eg)
end
function c4210014.otop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c4210014.spcfilter,nil,e,tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		--tograve
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(4210001,3))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_RELEASE)
		e1:SetTarget(c4210014.tgtg)
		e1:SetOperation(c4210014.tgop)
		e1:SetReset(RESET_EVENT+0xd7b0000)
		tc:RegisterFlagEffect(0,RESET_EVENT+0xd7b0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210014,3))
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end	
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end	
end
function c4210014.tgfilter(c,e,tp)
	return c:IsSetCard(0x2af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4210014.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c4210014.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c4210014.tgfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c4210014.tgfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c4210014.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
		tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
	end
end
function c4210014.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x2af)
end
function c4210014.spfilter(c,tp)
	return c:IsFaceup() and c:GetFlagEffect(4210010)~=0 and c:IsControler(tp) and c:IsReleasable()
end
function c4210014.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c4210014.spcon(e,c)	
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rg=Duel.GetReleaseGroup(tp):Filter(c4210014.spfilter,nil,ft,tp)
	local rgc=rg:GetCount()
	local c=e:GetHandler()
	return (rgc>0 and Duel.CheckReleaseGroup(tp,c4210014.spfilter,1,nil,rgc,tp) and c:IsLocation(LOCATION_HAND))
		or (rgc>1 and Duel.CheckReleaseGroup(tp,c4210014.spfilter,2,nil,rgc,tp) and c:IsLocation(LOCATION_DECK))
end
function c4210014.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rg=Duel.GetReleaseGroup(tp):Filter(c4210014.spfilter,nil,ft,tp)
	local g=nil
	local rec = (c:IsLocation(LOCATION_DECK) and {2} or {1})[1]
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,rec,rec,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c4210014.mzfilter,1,1,nil,tp)
		if c:IsLocation(LOCATION_DECK) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g2=rg:Select(tp,1,1,g:GetFirst())
			g:Merge(g2)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c4210014.mzfilter,rec,rec,nil,tp)
	end
	Duel.Release(g,REASON_COST)
	c:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
	c:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
    c:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210014,1))
	c:RegisterFlagEffect(4210014,RESET_EVENT+0xcff0000,0,0)
end