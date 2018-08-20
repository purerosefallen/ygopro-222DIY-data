--晶石召唤术士 泽洛
if c22280001 then
c22280001.named_with_Spar=true
c22280001.named_with_Zero=true
function c22280001.initial_effect(c)
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
	e2:SetCondition(c22280001.sprcon)
	e2:SetOperation(c22280001.sprop)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22280001,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c22280001.target)
	e3:SetOperation(c22280001.operation)
	c:RegisterEffect(e3)
end
function c22280001.sprfilter(c)
	return c:IsRace(RACE_ROCK)
end
function c22280001.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c22280001.sprfilter,1,nil)
end
function c22280001.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.SelectReleaseGroup(tp,c22280001.sprfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c22280001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22280001.rsfilter(c)
	return c:GetType()==TYPE_RITUAL+TYPE_SPELL
end
function c22280001.rmfilter(c,mc,seq)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand() and c22280001.isfit(c,mc) and c:GetSequence()>=seq
end
function c22280001.isfit(c,mc)
	return mc.fit_monster and c:IsCode(table.unpack(mc.fit_monster))
end
function c22280001.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22280001.rsfilter,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local rscard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			rscard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if rscard:IsAbleToHand() then
		Duel.SendtoHand(rscard,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rscard)
		local mg=Duel.GetMatchingGroup(c22280001.rmfilter,tp,LOCATION_DECK,0,nil,rscard,seq)
		if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22280001,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	else 
		Duel.ShuffleDeck(tp)
	end
end
end
-----module part-----
if not scorp then
scorp={}
scorp.loaded_metatable_list={}
function scorp.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=scorp.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			scorp.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function scorp.check_set(c,setcode,v,f,...) 
	local codet=nil
	if type(c)=="number" then
		codet={c}
	elseif type(c)=="table" then
		codet=c
	elseif type(c)=="userdata" then
		local f=f or Card.GetCode
		codet={f(c)}
	end
	local ncodet={...}
	for i,code in pairs(codet) do
		for i,ncode in pairs(ncodet) do
			if code==ncode then return true end
		end
		local mt=scorp.load_metatable(code)
		if mt and mt["named_with_"..setcode] and (not v or mt["named_with_"..setcode]==v) then return true end
	end
	return false
end
function scorp.check_set_Spar(c)
	return scorp.check_set(c,"Spar")
end
function scorp.check_set_Zero(c)
	return scorp.check_set(c,"Zero")
end
end